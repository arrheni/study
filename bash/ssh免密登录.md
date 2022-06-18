一、ssh远程登录验证方式
ssh远程登录，两种身份验证:
1、用户名+密码
2、密钥验证

机器1生成密钥对并将公钥发给机器2，机器2将公钥保存。
机器1要登录机器2时，机器2生成随机字符串并用机器1的公钥加密后，发给机器1。
机器1用私钥将其解密后发回给机器2，验证成功后登录
二、用户名密码登录验证

如上图所示，机器1要登录到机器2

ssh 机器2的ip（默认使用root用户登录，也可指定，如：ssh a@192.168.0.124 表示指定由a用户登录机器2）
输入机器2中a用户的密码即可登录到机器2,a不输入情况下默认为机器1当前用户
输入exit回到机器1
三、免密登录
1、生成密钥
输入命令ssh-keygen
按三次回车，完成生成私钥和公钥

查看生成的公钥和私钥

2、将公钥传给需要登录的远程服务器
使用ssh-copy-id ip将公钥传送到远程服务器

3、免密登录测试
使用ssh ip直接登录到远程服务器

四、QA
1、如果找不到ssh-copy-id命令，可以使用如下方式拷贝密钥
解决方案：cat ~/.ssh/id_*.pub | ssh root@192.168.114.43 ‘cat >> .ssh/authorized_keys’

2、Authentication refused: bad ownership or modes for file /home/btms/.ssh/authorized_keys
解决方案：sshd为了安全，对属主的目录和文件权限有所要求。如果权限不对，则ssh的免密码登陆不生效。检测目录权限，把不符合要求的按要求设置权限即可。
用户目录权限为 755 或者 700，就是不能是77x。
.ssh目录权限一般为755或者700。
rsa_id.pub 及authorized_keys权限一般为644
rsa_id权限必须为600
————————————————
版权声明：本文为CSDN博主「浪子吴天」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
原文链接：https://blog.csdn.net/carefree2005/article/details/111679673



#### 1、服务器端开启密钥登录模式

`/etc/ssh/sshd_config`

```
# 是否允许 root 远程登录
PermitRootLogin yes

# 密码登录是否打开
PasswordAuthentication yes

# 开启公钥认证
RSAAuthentication yes # 这个参数可能没有 没关系
PubkeyAuthentication yes

# 存放登录用户公钥的文件位置
# 位置就是登录用户名的家目录下的 .ssh
# root 就是 /root/.ssh
# foo 就是 /home/foo/.ssh
AuthorizedKeysFile .ssh/authorized_keys
```

`service sshd restart`

#### 2、用户端创建自己的秘钥对

```
ssh-keygen -t rsa -C "your@email.com"

cd ~/.ssh/

# 查看公钥
cat id_rsa.pub

# 配置登录别名 省去输 ip 麻烦
vi config

Host examp # 登录的服务器别名 ssh examp 就可以了
    HostName 233.233.233.233 #要登录的服务器ip
    Port 22
    User root #登录名
    IdentityFile ~/.ssh/id_rsa #你的私钥路径
    ServerAliveInterval 30
    TCPKeepAlive yes
```

#### 3、将你的公钥添加至服务器端的公钥凭证

```
echo 你的公钥内容 >> ~/.ssh/authorized_keys
```

#### 4、用户端即可免密登录

```
ssh exmap
```
