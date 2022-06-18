#!/bin/sh
JAR_PATH=removeEhcache.jar
echo  '输入参数，j为精确查询， a是全部清除，q退出 ' 
read -p '输入参数: ' input_var_1

if [ $input_var_1 = "j" ] ; then 
	echo " 需输入参数，如(T_UDMP_SUB_SYSTEM_INFO,null) "
	read -p "输入：" input_var_2
	PARAM="$input_var_2 udmp-InmutableCache 1"
elif [ $input_var_1 = "a" ] ; then
	PARAM="udmp-InmutableCache 2"
else
	echo "退出。。。"
	exit 0
fi
#PARAM="T_UDMP_SUB_SYSTEM_INFO,null udmp-InmutableCache 1"
 
echo "执行命令：java -jar $JAR_PATH $PARAM"
VAR=$(java -jar $JAR_PATH $PARAM)
 
# 判断调用是否成功
if [ $? -ne 0 ]; then
		echo "=====调用失败 =====" 
		exit 1
fi
 
# 成功获得返回值
echo $VAR
 
exit 0
