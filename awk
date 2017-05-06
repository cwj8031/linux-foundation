1.awk特点

        文本与数据处理工具
        与sed不同之处-->可以编程-->处理灵活，功能更强大

2.awk应用

        统计
        制表
        其他功能

3.awk应掌握的学习内容

	awk行处理方式与格式
	awk内嵌参数的应用
	awk内嵌程序的应用

4.awk处理方式

	awk一次处理一行内容
	awk可以对每行进行切片处理
		例子：用awk输出首个单词   awk  '{print $1}'
5.awk使用格式

	命令行格式
	awk [options] 'command' file(s)
	脚本格式
	awk -f awk-script-file file(s)

6.命令行格式——基本格式
	awk [options] 'command' file(s)
	command:pattern{awk操作命令｝
	pattern:正则表达式组成；逻辑判断式组成
	｛awk操作命令｝：内置函数print（）   printf（） ；
   	控制指令：if（）｛……｝else｛……｝；while（）｛……｝；

7.awk内置参数应用
	awk内置变量1
		$0:表示当前行
		$1:每行第一个字段
		$2:每行第二个字段

		这些字段是如何划分的呢，这个时候要用到options

	awk内置参数：分隔符
		options：-F field-separator（默认为空格）
		例如：awk -F ‘：’  ‘｛print $3｝’  /etc/passwd

		打印两个字段，两种方法
		awk -F ':'    '{print  $1,$3}'    /etc/passwd   用逗号分隔
		awk -F ':'     '{print  $1  "  "  $3}'   /etc/passwd  打印空格分开   或者加‘\t’  table健
		添加说明字段：
		awk -F ':' '{print "User:  "$1 "  " "UID: "$3}'  /etc/passwd

	awk内置变量2
		NR：每行的记录号（每行的行号）
		NF：字段数量变量（这一行中字段的总数）
		FILENAME：正在处理的文件名

		awk -F ':'  '{print    NR,NF,FILENAME}'  /etc/passwd    记住：NR和NF前面都没有$


8.awk内置参数应用的例子
案例一：显示/etc/passwd每行的行号，每行的列数，对应行的用户名（print，printf）
	awk  -F ':'  '{print  "Line: "NR,"Col:"NF,"User:"$1}'  /etc/passwd
	awk -F ':' '{printf("Line:%s Col:%s User:%s\n",NR,NF,$1)}'  /etc/passwd
案例二：显示/etc/passwd中用户ID大于100的行号和用户名（if……else……）
	awk -F ':'  '{if ($3>100) print  "Line: "NR,"User: "$1}'  /etc/passwd
案例三：在服务器log中找出'Error’的发生日期
	sed  '/Error/p'  fresh.log  |awk '{print $1}'
	awk '/Error/{print $1}'  fresh.log


9.awk——逻辑判断式

	command：pattern｛awk操作命令｝
	pattern：正则表达式；逻辑判断式

	awk逻辑
		~，！~       		匹配正则表达式
		==，！=，<,>		判断逻辑表达式

	awk  -F   ':'  '$1~/^m.*/{print $1}'  passwd  匹配用户名为m开头的  用户名
	awk  -F   ':'  '$1!~/^m.*/{print $1}'  passwd    取反

	awk -F  ':'  '$3>100{print $1,$3}'  passwd   取出$3 大于100 的用户名 UID 


10.扩展格式

	awk  [options]  'command'  file(s)

	command2扩展：
		BEGIN{print “start”}pattern{commands}END{print "end"}

	案例一：
	制表显示/etc/passwd  每行的行号，每行的列数，对应行的用户名
		awk  -F  ":"  'BEGIN{print "Line  Col  User"}{print NR,NF,$1}END{print "-------"FILENAME"-------"}'     passwd
	

11.awk处理过程

	案例一：
	统计当前文件夹下的文件/文件夹占用的大小

	ls -l |awk  'BEGIN{size=0}{size+=$5}END{print "size  is"   size/1024/1024"M"}'

	案例二：
	统计显示/etc/passwd的账户总人数

	awk  -F ':'   'BEGIN{count=0}$1!~/^$/{count++}END{print "count =" count}' passwd

	统计显示UID大于100的用户名

	awk   -F ':'  'BEGIN{count=0}{if ($3>100) name[count++]=$1}END{for (i=0;i<count;i++) print i,name[i]}'  passwd

	统计netstat -anp 状态下为LISTEN和CONNECTED的连接数量

	netstat   -anp |awk '$6~/CONNECTED|LISTEN/{sum[$6]++}END{for (i in sum) print i,sum[i]}'



