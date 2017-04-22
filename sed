二、sed
1、原理
文本或管道输入-->读入一行到模式空间-->sed命令处理-->输出到屏幕

（模式空间，即为临时缓冲区，没有处理的直接打印到屏幕，例如 sed 'p'  /ect/passwd 就是p打印一遍，没有处理的行都打印一遍，就是每行打印两遍）处理的，将处理后的输出到屏幕。

$ sed 'p' /etc/passwd
root:x:0:0:root:/root:/bin/bash
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin

-n：静默输出，就是没处理过的就不输出，一般与p结合输出处理过的

$ sed  -n 'p' /etc/passwd   #所有的行，处理动作是p（打印），所以所有的行都输出
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/sbin/nologin
daemon:x:2:2:daemon:/sbin:/sbin/nologin
adm:x:3:4:adm:/var/adm:/sbin/nologin
lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
sync:x:5:0:sync:/sbin:/bin/sync

注意：
一次处理一行内容，读一行处理一行
sed不改变文件内容，要改变可以使用重定向或者-i命令

命令格式：sed  [options]  ‘command’  files
脚本格式：sed -f scriptfile files （一般不用）
2、选项（options）：-n   -e  -i
 command=行定位（正则）+sed命令（处理动作）
3、定界：（处理哪些内容，要使用正则选定文本）
单行定界：/正则/  ;  1  2
多行定界：/正则/,/正则/ ;   1,2
4、处理动作：
a（新增）  d  p   
s：替换，替换的时候要注意是每一行的第一个替换，还是每一行的全局替换  

举例：
1、sed  -n  '/root/p'  file
2、sed  -e  '10,20d'  -e  's/false/true/g'  file
3、nl   file  |sed -n '10p' ;        nl   file  |sed -n '10,20p' 
4、sed  -n '/mooc/p'   /etc/passwd
5、取反，在行号后面加！：
nl    file  |  sed  -n   '10!p'  
nl    file  |  sed  -n   '10,20!p'  

6、间隔行：1~2(初始~步长）

（操作命令：a  i  c  d）
7、在第五行后面添加分隔符：
nl  file  |sed  -n  '5a  =============' 
nl  file  |sed  -n  '1,5a  =============' 
8、在第五行的前面添加分隔符（i）
9、把第五行替换掉（c）
nl  file |sed  '40c  sdfasdfasg'
10、删除是d

案例一：优化服务器配置
“在ssh的配置文件中加入相应的文本：
Port 52113
PermitRootLogin no
PermitEmptyPasswords no
”
sed  '$a  prot 52113  \nPermitRootLogin no'   ssh_config
这个时候是顶格的：
$ cat ssh_config 
asdassf
port 2222
permitrootlogin no

要空四格：
sed  '$a \    prot 52113  \n    PermitRootLogin no'   ssh_config
$ sed  '$a \    prot 52113  \n    PermitRootLogin no'   ssh_config
asdassf
port 2222
permitrootlogin no
    prot 52113  
    PermitRootLogin no

案例二：删除空行
sed  '/^$/d'  file 

案例三：服务器log处理
sed  -n  '/Error/p'   log
