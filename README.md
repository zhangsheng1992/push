# push
<h2>a small release program based on git.</h2>

<h3>support liunx and Mac OS plat</h3>

<h3>Environment depends</h3>
		git		A version management repository
		rsync	`remote sync｀ is called,Data mirroring backup tool for class UNIX system
		php 	A scripting language, if you need a management interface, of course ,you can use other
				sciprt language.

<h3>but how to use it?</h3>

first,read this note to konw how we can do?
you may need to update the config file at first, it in the system folder named conf,as follows
server the webservice  vhost folder, you need `ssh` trust, otherwise your kown what will hanppend.


second,you need a git repository include a `master` and a `work` branches.

you can use 

command git branch `name branch` 

to build  work branch


then use `push init` to initial this work directory

command ./push.sh init


the shell script will bulid `version` folder to save all your old version code and bulid `log` folder.

the `log` folder,The contents are as follows

access.log  save all your operation message

error.log  save all your error message

version  save all your version message

If it's not necessary, please don not delete its.


<h3>how to commit your code?</h3>

fisrt,commit your local update to `work` branch, As long as you are defined by the 'work' branch can be.

So you can deploy this script on the server and update your code  in local. As long as the local push 

to the `work` branch can be

command ./push.sh merge


the shell will merge your code to master branch from your `work` branch and bulid a folder `execute`, 

this folder include all your commits in this time.

then use 

commangd ./push.sh commit

to push your code to the develpment webservice.


<h3>you can rollback to any old version at any time. use </h3>

command ./push.sh rollback  [verison number]  


<h3>what is the version number? I do not konw, but you can use </h3>

commang ./push.sh list

to see the version number, any commit operate will wirte a log, so do not worry you may lost your file




小型发布程序
平台支持 liunx Mac os
依赖于
	git   		版本控制工具 本脚本基于git开发
	rsync	 	类unix平台上自带的同步工具
	php 		管理界面由此脚本开发,当然你可以用自己的脚本编写,甚至可以不适用管理界面,如果你喜欢命令行的话,
				这个主要是方便美工前端人员

如何去使用?

	首先,你需要一个版本仓库,仓库上需要有2个分支,master分支作为默认发布分支,work作为开发分支,在配置文件里面定义好相关配置,然

	后进行初始化. 初始化之前,先去你的版本仓库使用

	command git branch查看你的分支 

	默认会有一个master,但不一定有work分支 如果没有 使用

	command git branch <分支名称> 创建一个work分支 

	这些工作完毕后,将脚本部署到版本目录同级位置,使用下面的命令初始化你的工作目录

	command  ./push.sh init

	初始化过程会监测你的分支情况并在项目下创建,如果满足条件,将会创建version文件夹保存你的所有旧版本代码 创建log文件夹来保存

	日至信息 日志分为 

	access.log    纪录操作信息

	error.log     纪录错误信息

	version.log   纪录你的版本信息 

	如果没必要 请不要随便删除他们

现在我要发布代码,怎么办呢？

	首先把你的代码提交到｀work｀分支上 只要是｀work｀分支即可 所以你完全可以把这个脚本部署在服务器上

	而在你本地编写代码  只要本地推送到`work`分支即可,git的分支我就不讲解了 后面我会附上流程图去讲解发布流程

	然后使用 

	command ./push.sh merge  

	去生成发布包 生成完毕后,使用 

	command ./push.sh commit [commit message] 

	来提交代码 怎么样 很方便吧

不过我推到服务器上的代码有点问题  咋办呢？

	没关系 你可以使用

	command ./push.sh rollback [commit id] 

	来回滚到指定版本般代码,首次提交是没有前期版本作为回滚的,所以建议初始化完以后线提交一个版本的稳定代码

我不知道 commit id?

	command ./push.sh log

	来查看 日志会标出现在先上上线的是哪一版

当我使用过一段时间以后,我发现我的备份版本太多了,我像删除一些早期版本
	
	command ./push clean ［commit id]

 	如果不指定参数 只会保留最新提交的10个版本的代码 所以使用时一定请注意







