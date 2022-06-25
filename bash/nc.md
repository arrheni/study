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
