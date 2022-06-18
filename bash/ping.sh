在网上针对shell脚本ping监控主机是否存活的文档很多，但大多都是ping一次就决定了状态，误报率会很高，为了精确判断，ping三次不通再发告警，只要一次ping通则正常。于是，今天中午抽出点时间总结了下面脚本。

脚本功能：通过Ping命令监控主机是否存活，如果ping失败则继续ping，三次不通就认为主机宕机或网络有问题，这时就可以发送邮件告警了。

方法1：

#!/bin/bash
# blog：http://lizhenliang.blog.51cto.com
 
IP_LIST="192.168.18.1 192.168.1.1 192.168.18.2"
for IP in $IP_LIST; do
    NUM=1
    while [ $NUM -le 3 ]; do
        if ping -c 1 $IP > /dev/null; then
            echo "$IP Ping is successful."
            break
        else
            # echo "$IP Ping is failure $NUM"
            FAIL_COUNT[$NUM]=$IP
            let NUM++
        fi
    done
    if [ ${#FAIL_COUNT[*]} -eq 3 ];then
        echo "${FAIL_COUNT[1]} Ping is failure!"
        unset FAIL_COUNT[*]
    fi
done
说明：将错误IP放到数组里面判断是否ping失败三次

方法2：

#!/bin/bash
# blog：http://lizhenliang.blog.51cto.com
 
IP_LIST="192.168.18.1 192.168.1.1 192.168.18.2"
for IP in $IP_LIST; do
    FAIL_COUNT=0
    for ((i=1;i<=3;i++)); do
        if ping -c 1 $IP >/dev/null; then
            echo "$IP Ping is successful."
            break
        else
            # echo "$IP Ping is failure $i"
            let FAIL_COUNT++
        fi
    done
    if [ $FAIL_COUNT -eq 3 ]; then
        echo "$IP Ping is failure!"
    fi
done
说明：将错误次数放到FAIL_COUNT变量里面判断是否ping失败三次

方法3：

#!/bin/bash
# blog：http://lizhenliang.blog.51cto.com
 
ping_success_status() {
    if ping -c 1 $IP >/dev/null; then
        echo "$IP Ping is successful."
        continue
    fi
}
IP_LIST="192.168.18.1 192.168.1.1 192.168.18.2"
for IP in $IP_LIST; do
    ping_success_status
    ping_success_status
    ping_success_status
    echo "$IP Ping is failure!"
done
说明：这个个人觉得比较巧妙，利用for循环将ping通就跳出循环继续，如果不跳出就会走到打印ping失败
