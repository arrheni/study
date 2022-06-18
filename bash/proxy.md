这几个工具都支持带用户名密码认证的上级代理，代理可以是 socks4/5，http-connect 等，glider 和 gost 还额外支持 ss，ssr 作为上级代理，但是对用户名密码或者附加参数中带‘@’号处理有些问题。

还需要注意，代理链中的第二级代理（最后一级？），‘必须’要具有外网 IP ，不然很容易失败。(这也是为什么要求支持用户名密码认证)

范例：
本地代理监听 0.0.0.0:7777 端口，上级两个代理级联（代理链），第一代理为： 192.168.2.20:7575 ，第二代理为：1.1.1.1:10086 （用户名 user ， 密码 passwd）

gost：(https://github.com/ginuerzh/gost)

gost -L=:7777 -F=socks5://192.168.2.20:7575 -F=socks5://user:passwd@1.1.1.1:10086 -D

glider: (https://github.com/nadoo/glider)

glider -listen 0.0.0.0:7777 -forward socks5://192.168.2.20:7575,socks5://user:passwd@1.1.1.1:10086 -verbose

proxychains+microsocks (https://github.com/rofl0r/proxychains-ng, https://github.com/rofl0r/microsocks)

U$lP6$ly

proxychains 配置文件：
strict_chain
proxy_dns
remote_dns_subnet 224
tcp_read_time_out 15000
tcp_connect_time_out 8000
[ProxyList]
socks5 192.168.2.20 7575
socks5 1.1.1.1 10086 user passwd

命令行：
proxychains4 microsocks -p 7777

访问流程：
客户端请求-->SOCKS5:7777-->SOCKS5:192.168.2.20:7575-->SOCKS5:1.1.1.1:10086-->远程服务

gost 启动很慢，内存占用极高，glider 比较均衡，这两个都是 golang 编写的；proxychains+microsocks 是 C 写的，占用最小，适合配置不高的设备，但是需要自己编译，配置稍显麻烦。

优选IP 172.64.145.223
公网IP 222.129.58.10
自治域 AS4808
运营商 China Unicom
经纬度 116.39720,39.90750
位置信息 Beijing,Beijing,CN
设置宽带 0 Mbps
实测带宽 36 Mbps
峰值速度 4732 kB/s
往返延迟 182 毫秒
数据中心 Los Angeles,North America
总计用时 253 秒
