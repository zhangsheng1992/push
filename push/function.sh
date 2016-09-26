#! /bin/sh
# ----------------------------------------------------------------------
# filename function.sh
# reversion 1.1
# author: zhangsheng_1992@sohu.com
# date 2016-09-19
# discription 发布程序函数库
# ----------------------------------------------------------------------

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



#发布 $1 版本描述信息
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

	push
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

#推送到服务器
push(){
	var=$SERVICEADDRESS
	var=${var//,/ }
	for element in $var   
	do  
		if [ ! -n "$1" ]; then
	    	rsync --delete -avzh --exclude ".git"  -e ssh "$ROOTDIR""/execute/" $element 2>>$ERRORLOG 1>/dev/null 
		else
			rsync -avzh --delete --exclude ".git"  -e ssh "$ROOTDIR""/version/""$1/" $SERVICEADDRESS 2>>$ERRORLOG 1>$ACCESSLOG
		fi

		if [ "$?" == "1" ]; then
			echo "[error] `tail -n 1 $ERRORLOG`"
			exit 0
		fi  
	done 
}

#回滚 $1 回滚版本的commitid
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

	push $1
	awk -v number=$NUMBER '{ if(NR==number){gsub(/<线上>/,"",$1);print "<线上>"$0 }else{gsub(/<线上>/,"",$1);print $0}}' $VERSIONLOG > version.bak
	mv version.bak $VERSIONLOG
}

#回滚日志文件
changeversion(){
	sed 's/<线上>//' $VERSIONLOG > version.bak
	mv version.bak $VERSIONLOG
}

#清除旧的备份文件 默认保留最近的10个版本  $1 要删除的版本的commit id
clean(){
	if [ ! -n "$1" ]; then
		NUMBER=`cat $VERSIONLOG | wc -l`
		awk -v num="$NUMBER" '{ if(NR > num-4){ print $0 } }' $VERSIONLOG  > version.bak
		RMDIR=`awk -v num="$NUMBER" '{ if(NR < num-4){ print $3" " } }' $VERSIONLOG `
	else
		NUMBER=$1
		awk -v number="$NUMBER" '{ if($3 != number){ print $0 } }' $VERSIONLOG > version.bak
		RMDIR=`awk -v number="$NUMBER" '{ if( $3 == number ){ print $3 }  }' $VERSIONLOG`
	fi
	rm -rf "$ROOTDIR""/version/""$RMDIR"
	mv version.bak $VERSIONLOG
}