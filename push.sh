#! /bin/sh

# 版本发布程序
# author: zhangsheng_1992@sohu.com
# date 2016-09-19
# version 1.0
# 引入函数库
source ./system/function.sh
ROOTDIR=`pwd`
# 配置文件路径
CONFIG="$ROOTDIR"'/system/conf'
# 版本目录
BASEDIR="$ROOTDIR"'/test'
# 项目备份路径
BAKDIR="$ROOTDIR"'/system/old'
# log文件
LISTFILE="$ROOTDIR"'/log'
# web服务器发布路径
ADDRESS=$(GetKey "server.address")
# 开发分支
WORKBRANCH='test'
# 发布分支
PRODUCTION=$(GetKey "git branch.production")

commit
# cd $BASEDIR
# echo $ADDRESS
# echo $(GetKey "server.address")
# echo $(GetKey "file.listfile")
# case "$1" in 
# 	submit)
# 		submit
# 		;;
# 	rollback)
# 		rollback
# 		;;
# 	list)
# 		list
# 		;;
# 	pull)
# 		pull
# 		;;
# 	init)
# 		init
# 		;;
#	merge)
# 		merge
# 		;;





# var=’1,2,3,4,5’  
# var=${var//,/ }    #这里是将var中的,替换为空格  
# for element in $var   
# do  
#     echo $element  
# done 
