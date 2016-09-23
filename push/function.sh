#! /bin/sh
# 发布程序函数库

# 合并分支代码
merge(){
	cd $WORKDIR
	if [ "`git branch | grep $WORKBRANCH | awk '{print $1}'`" != '＊' ] ; then
		git checkout $WORKBRANCH >> /dev/null
		if [ "$?" = "1" ]; then
			echo "[error] `tail -n 1 $ERRORLOG`"
			exit 0
		fi
	fi

	git pull 1> /dev/null  && git checkout $MASTERBRANCH > /dev/null && git merge $WORKBRANCH 1> /dev/null && git push 1> /dev/null && git checkout $WORKBRANCH > /dev/null  
	
	if [ "$?" = "1" ]; then
		echo "[error] `tail -n 1 $ERRORLOG`"
		exit 0
	fi

	if [ ! -d "$ROOTDIR""/execute" ]; then
	 	rm -rf "$ROOTDIR""/execute"
	fi

	cp -rfp $WORKDIR  "$ROOTDIR""/execute"

	if [ "$?" = "1" ]; then
		echo "[error] `tail -n 1 $ERRORLOG`"
		exit 0
	fi
}


# 初始化目录
init(){

	if [ ! -d "$ROOTDIR""/version" ];then
		mkdir "$ROOTDIR""/version"
	fi

	if [ ! -d "$LOGDIR" ];then
		mkdir "$LOGDIR"
	fi

	cd $WORKDIR
	# 检测发布分支
	if [ `git branch | grep master | awk '{print $1}'` != 'master' ] && [ `git branch | grep master | awk '{print $2}'` != 'master' ]; then
		echo 'master branch not found!'
	fi
	# 检测开发分支
	if [ "`git branch | grep test | awk '{print $1}'`" == 'test' ] && [ "`git branch | grep test | awk '{print $2}'`" != 'test' ]; then
		echo 'test branch not found!'
	fi

	cd $ROOTDIR
}



#发布
commit(){
	cd $ROOTDIR
	if [ ! -d "$ROOTDIR""/execute" ]; then
		echo '[error]please use [merge] param to update your code or use [rollback] param to reset code at first!'
		exit 0
	fi

	if [ ! -n "$1" ]; then
		echo "input version message:"
		read input
		MESSAGE="$input"
	else
		MESSAGE=$1
	fi

	rsync --delete -avzh --exclude ".git"  -e ssh "$ROOTDIR""/execute/" $SERVICEADDRESS 2>>$ERRORLOG 1>/dev/null 
	if [ "$?" == "1" ]; then
		echo "[error] `tail -n 1 $ERRORLOG`"
		exit 0
	fi

	COMMITID=`date|md5`
	changeversion $VERSIONLOG
	echo '<线上>'` date "+%Y-%m-%d %H:%M:%S"` " $COMMITID" " $MESSAGE" >> $VERSIONLOG 
	mv "$ROOTDIR""/execute" "$ROOTDIR""/version/""$COMMITID"

	if [ "$?" == "1" ]; then
		echo "[error] `tail -n 1 $ERRORLOG`"
		exit 0
	fi
	echo '[ok] commit completed!'
}

#显示日志
log(){
	awk '{if(NR==1){ print $0  }else{ print $0 } }' $VERSIONLOG | sort -r
}

#回滚
rollback(){
	
	if [ ! -n "$1" ]; then
		echo "[error] you should choice which version you want to rollback!"
		exit 0
	fi
	
	NUMBER=`awk -v COMMITID=$1 '{ if( $3 == COMMITID || $4 == COMMITID) print FNR  }' $VERSIONLOG`
	if [ ! -n "$NUMBER" ]; then
		echo "[error] can not found this version!use [log] param to look for!"
		exit 0
	fi

	if [ ! -d "$ROOTDIR""/version/""$COMMITID" ]; then
		echo "[error] can not found back file!"
		exit 0
	fi

	rsync -avzh --delete --exclude ".git"  -e ssh "$ROOTDIR""/version/""$1/" $SERVICEADDRESS 2>>$ERRORLOG 1>$ACCESSLOG
	awk -v number=$NUMBER '{ if(NR==number){gsub(/<线上>/,"",$1);print "<线上>"$0 }else{gsub(/<线上>/,"",$1);print $0}}' $VERSIONLOG > version.bak
	mv version.bak $VERSIONLOG
}

#回滚日至文件
changeversion(){
	sed 's/<线上>//' $VERSIONLOG > version.bak
	mv version.bak $VERSIONLOG
}

# clean(){}
