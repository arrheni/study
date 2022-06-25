# nc 命令

rhel 6  和 rhel 7 的nc不是同一个命令；

netcat 的nc有-z选项

ncat 的nc没有-z选项

netcat 的另一个升级功能的命令是 socat

|              | nc     | website                        |                                                   |
| ------------ | ------ | ------------------------------ | ------------------------------------------------- |
| redhat 6     | netcat | http://netcat.sourceforge.net/ | nc -zv ucpubgid.com 80                            |
| redhat 7     | Ncat   | https://nmap.org/ncat          | nc 10.9.5.15 80 < /dev/null && echo "tcp port ok" |
| debian 10 11 | netcat | http://netcat.sourceforge.net/ | nc -zv ucpubgid.com 80                            |


　　先说明一下，[nc](http://www.tutorialspoint.com/unix_commands/nc.htm) 与 netcat 是同一个东西，[ncat](https://nmap.org/ncat/) 是 [nmap](https://nmap.org/) 套件的一部分，ncat 与 [socat](http://www.dest-unreach.org/socat/) 都号称自己是 nc 的增强版。

　　scocat 端口释放很慢。

【 **回显** 】

 **1、** TCP 回显

1.1、仅仅回显，不打印。

| 12 | `ncat -c ``cat` `-k -l 6666``ncat -e ``/bin/cat` `-k -l 6666` |
| -- | --------------------------------------------------------------------------- |

1.2、回显并打印。

| 1 | `socat -d -d -``v` `tcp-l:6666,fork ``exec``:``'/bin/cat'` `#两个-d是为了显示连接状况` |
| - | ------------------------------------------------------------------------------------------------ |

 **2、** UDP 回显。

| 12 | `ncat -c ``cat` `-k -u -l 6666``ncat -e ``/bin/cat` `-k -u -l 6666` |
| -- | ----------------------------------------------------------------------------------- |

 **3、** TCP 端口转发。（[ncat端口转发](http://www.jianshu.com/p/9db274484811)）

| 12 | `# 监听本机 7777 端口，将数据转发到 192.168.7.8 的 8888 端口``ncat --sh-``exec` `"ncat 192.168.7.8 8888"` `-l 7777 --keep-``open` |
| -- | --------------------------------------------------------------------------------------------------------------------------------------------------- |

【nmap 常用扫描命令】

| 12345678 | `#快速扫描一台主机的著名端口``nmap -F -n -sTU -``v` `192.168.0.xx` `#快速扫描多台主机的著名端口``nmap -F -n -sTU -``v` `192.168.0.130-168` `#扫描20-200端的端口``nmap -n -sTU -``v` `-p 20-200 192.168.0.xx` |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

【扫描 dhcp 服务器】

[![wKiom1mShtaQdDCsAAATUW6j4wc116.png](https://s4.51cto.com/wyfs02/M01/9E/90/wKiom1mShtaQdDCsAAATUW6j4wc116.png "dhcp.png")](https://s4.51cto.com/wyfs02/M01/9E/90/wKiom1mShtaQdDCsAAATUW6j4wc116.png)

 **1、** [DHCP协议详解](http://blog.chinaunix.net/uid-29158166-id-4575490.html)

 **2、** [Nmap扫描教程之网络基础服务DHCP服务类](http://blog.csdn.net/daxueba/article/details/46635379)

| 12345 | `# 广播（broadcast-dhcp-discover）``nmap --script broadcast-dhcp-discover` `# 指定主机。（dhcp-discover）``nmap -sU -p 67 --script=dhcp-discover 192.168.0.xx` |
| ----- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |

相关阅读：[端口扫描之王——nmap入门精讲（一）](http://www.cnblogs.com/st-leslie/p/5115280.html?spm=a2c6h.12873639.article-detail.12.2873196fpe9sUP)


ss command is a tool that is used for displaying network socket related information on a Linux system.

Nmap is short for Network Mapper. It is an open-source Linux cmd-line tool that is used to scan IPs & ports in a nw & to detect installed apps. Nmap allows nw admins to find which devices r running on their nw, discover open ports & services, and detect vulnerabilities.

Ping cmd is used to test d ability of d src system to reach a specified destination system.

Traceroute is a nw diagnostic tool used to track in realtime d pathway taken by a pkt on an IP nw from src to dest,reporting d IPaddr of all d routers it pinged in b/n

Ethtool is a Network Interface Card (NIC) utility/configuration tool. Ethtool allows you to query and change your NIC settings such as the Speed, Port, auto-negotiation and many other parameters.


Dig (Domain Information Groper) is a powerful cmd-line tool for querying DNS name servers.It allows you to query info abt various DNS records, including host addresses, mail exchanges, & name servers. A most common tool among sysadmins for troubleshooting DNS problems.


Netcat is one of d powerful networking tool,security tool or nw monitoring tool. It acts like cat cmd over a nw.

It is generally used for:
Port Scanning /listening/redirection
open Remote connections
Read/Write data across network
Network debugging
Network daemon test


The socat command shuffles data between two locations. One way to think of socat is as the cat command which transfers data between two locations rather than from a file to standard output.Tcpdump is a command line utility that allows you to capture and analyze network traffic going through your system. It is often used to help troubleshoot network issues, as well as a security tool.


Tcpdump is a command line utility that allows you to capture and analyze network traffic going through your system. It is often used to help troubleshoot network issues, as well as a security tool.

The top command is used to show the active Linux processes. It provides a dynamic real-time view of the running system. Usually, this command shows the summary information of the system and the list of processes or threads which are currently managed by the Linux kernel.

Wireshark is a packet sniffer and analysis tool. It captures network traffic on the local network and stores that data for offline analysis.
