#! /bin/sh
# 发布程序函数库

GetKey(){    
    section=$(echo $1 | cut -d '.' -f 1)    
    key=$(echo $1 | cut -d '.' -f 2)    
    sed -n "/\[$section\]/,/\[.*\]/{    
     /^\[.*\]/d    
     /^[ \t]*$/d    
     /^$/d    
     /^#.*$/d    
     s/^[ \t]*$key[ \t]*=[ \t]*\(.*\)[ \t]*/\1/p    
    }" $CONFIG  
}

# 合并分支代码
merge(){
	echo '-----------------merge start-----------------' >> update.log
	echo `date` >> update.log
	cd $BASEDIR
	git checkout $WORKBRANCH >> ../update.log 2>&1
	echo 'updating development branch code!'
	git pull >> ../update.log 2>&1
	git checkout $PRODUCTION >> ../update.log 2>&1
	git merge $WORKBRANCH >> ../update.log 2>&1
	git push >> ../update.log 2>&1
	echo 'updating  completed!'
	git checkout $WORKBRANCH >> ../update.log 2>&1
	cd $ROOTDIR
	if [ ! -d "/execute" ]; then
		rm -rf execute
	fi
	cp -rfp $BASEDIR execute
	echo 'work completed!'
	echo '-----------------merge end------------------' >> update.log
	cd $ROOTDIR
}

# 初始化目录
init(){
	echo "this operate will init this directory ,please input (y or n):" 
	read char
	if [ "$char" == "y" ] || [ "$char" == "yes" ] ; then 
	    echo 'init start!'
	else 
	    exit 0
	fi

	echo '------------------init start-----------------' >> update.log
	echo `date` >> update.log
	if [ ! -d "$ROOTDIR""/a" ]; then
		mkdir "$ROOTDIR""/a"
	fi

	if [ ! -d "$ROOTDIR""/b" ];then
		mkdir "$ROOTDIR""/b"
	fi

	if [ ! -d "$ROOTDIR""/c" ];then
		mkdir "$ROOTDIR""/c"
	fi

	if [ ! -d "$ROOTDIR""/old" ];then
		mkdir "$ROOTDIR""/old"
	fi

	cd $WORKBRANCH
	# 检测发布分支
	if [ `git branch | grep master | awk '{print $1}'` != 'master' ] && [ `git branch | grep master | awk '{print $2}'` != 'master' ]; then
		echo 'master branch not found!'
	fi
	# 检测开发分支
	if [ "`git branch | grep test | awk '{print $1}'`" == 'test' ] && [ "`git branch | grep test | awk '{print $2}'`" != 'test' ]; then
		echo 'test branch not found!'
	fi
	echo '------------------init end==-----------------' >> update.log
	cd $ROOTDIR
}

#发布
commit(){
	cd $ROOTDIR
	if [ ! -d "$ROOTDIR""/execute" ]; then
		echo 'please use [merge] to update your code or use [rollback] to reset code at first!'
		exit 0
	fi
	rsync -ravzh --exclude ".git"  -e ssh $WORKBRANCH $ADDRESS
	echo 'commit completed!'
	# 他excuete替换为a版本 其它的顺序后移 
}