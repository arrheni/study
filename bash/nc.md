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
