# push
<h2>a small release program based on git.</h2>

<h3>support liunx and Mac OS plat</h3>

<h3>Environment depends</h3>
	<ul style='list-style:none'>
		<li>git		A version management repository</li>
		<li>rsync	`remote sync｀ is called,Data mirroring backup tool for class UNIX system</li>
		<li>php 	A scripting language, if you need a management interface, of course ,you can use other
				sciprt language.</li>
    </ul>

<h3>but how to use it?</h3>

first,read this note to konw how we can do?
you may need to update the config file at first, it in the system folder named conf,as follows
server the webservice  vhost folder, you need `ssh` trust, otherwise your kown what will hanppend.


second,you need a git repository include a `master` and a `work` branches.
then use `push init` to initial this work directory

command ./push.sh init


the shell script will bulid `a`,`b`,`c`,`old` and `work` folder.

a 	The latest version

b 	Last version

c 	Antepenultimate version

old  early version

work your code in here



<h3>how to commit your code?</h3>

fisrt,commit your local update to `work` branch, in example , my work branch and work folder named

 'test',use

command ./push.sh merge


the shell will merge your code to master branch from your `work` branch and bulid a folder `execute`, 

this folder include all your commits in this time.

then use 

commangd ./push.sh commit

to push your code to the develpment webservice.


<h3>you can rollback to `a`,`b`,`c` or anohter old version at any time. use </h3>

command ./push.sh rollback [a,b,c|old verison number]  


<h3>what is the version number? I do not konw, but you can use </h3>

commang ./push.sh list

to see the version number, any commit operate will wirte a log, so do not worry you may lost your file 



