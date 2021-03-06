#! /bin/sh

# 版本发布程序
# author: zhangsheng_1992@sohu.com
# date 2016-09-19
# version 1.0
# 引入函数库
source function.sh

if [ ! -f "config" ]; then
	echo '[error] can not find config file!'
	exit 0
fi

while read line ; do  
    eval "$line"  
done < config

case "$1" in 
	commit)
		commit $2
		;;

	rollback)
		rollback $2
		;;

	log)
		log
		;;

	init)
		init
		if [ "$2" != "y" ]; then
			echo "this operate will init this directory ,please input (y or n):" 
			read char
			if [ "$char" != "y" ]; then 
			    exit 0
			fi
		fi
		;;

	merge)
		merge 2>> $ERRORLOG
		;;

	clean)
		clean $2
		;;
		
	*)
		echo 'can not find command '"$1"':'  'use {init|merge|log|commit|rollback|clean}'
		;;
esac 
