# mysql 安装和初始化

* 系统  Red Hat Enterprise Linux Server release 6.3 (Santiago)redhat 6.3 (Santiago
* 版本  MySQL Community Server 8.0.29

## 官网下载

下载地址：[MySQL :: Download MySQL Community Server](https://dev.mysql.com/downloads/mysql/)   https://dev.mysql.com/downloads/mysql/

选择相应的系统和版本下载：

| **RPM Bundle**                       | 8.0.29                                   | 1263.1M                                                                                           | [Download](https://dev.mysql.com/downloads/file/?id=511408) |
| ------------------------------------------ | ---------------------------------------- | ------------------------------------------------------------------------------------------------- | -------------------------------------------------------- |
| (mysql-8.0.29-1.el6.x86_64.rpm-bundle.tar) | MD5:`c43e1f798e271d3c752556dae27cfadd` | [Signature](https://dev.mysql.com/downloads/gpg/?file=mysql-8.0.29-1.el6.x86_64.rpm-bundle.tar&p=23) |                                                          |

```bash
wget https://dev.mysql.com/get/Downloads/MySQL-8.0/mysql-8.0.29-1.el6.x86_64.rpm-bundle.tar
```

## 安装

```bash
tar -xvf  mysql-8.0.29-1.el6.x86_64.rpm-bundle.tar
yum remove mysql mysql-libs-5.1.73-7.el6.x86_64
yum install mysql-community-server-8.0.29-1.el6.x86_64.rpm
```

## 初始化

```bash
service mysqld start
#获取root 初始化密码
tail -1000 /var/log/mysqld.log | grep root
mysql -u root -p qEhS19zVbW9
```

```sql
#修改本地登录初始化root口令
alter user 'root'@'localhost' identified by ''
#新增无限制登录的root口令
create user 'root'@'%' identified by 'core@WAS123';
GRANT ALL ON *.* TO 'root'@'%'; # *.*
FLUSH PRIVILEGES;
```

mysql5.7及以下版本新增用户的语句为：

```sql
GRANT ALL PRIVILEGES ON *.* TO 'myuser'@'%' IDENTIFIED BY 'mypassword' WITH GRANT OPTION;
FLUSH   PRIVILEGES;
```

其中"*.*"代表所有资源所有权限， “'root'@%”其中root代表账户名，%代表所有的访问地址，也可以使用一个唯一的地址进行替换，只有一个地址能够访问。如果是某个网段的可以使用地址与%结合的方式，如10.0.42.%。IDENTIFIED BY 'root'，这个root是指访问密码。WITH GRANT OPTION允许级联授权。
