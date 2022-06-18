With the running of the project, the size of Tomcat's log file catalina.out has increased day by day, and it is now several GB. If we don't do any processing, the file size of catalina.out will continue to increase until the hard disk space of our system is overwhelmed.

When the size of the Tomcat log file catalina.out is greater than 2GB, the Tomcat program may fail to start when it crashes without any error message prompt. In order to avoid this scenario, we need to rotate the catalina.out log file regularly.

Here Xiaobai uses the logrotate program that comes with CentOS6U5 to solve the log rotation problem of catalina.out. This way is relatively simple. Create a new file named tomcat in the/etc/logrotate.d/directory,

```
cat >/etc/logrotate.d/tomcat <<EOF
/usr/local/apache-tomcat-8.0.28/logs/catalina.out{
    copytruncate

    daily

    rotate 7

    missingok

    compress

    size 16M
}
EOF
```

The above configuration instructions:

```
/usr/local/apache-tomcat-8.0.28/logs/catalina.out{ # file to be rotated
    copytruncate # After creating a new copy of catalina.out, truncate the source catalina.out file

    daily # The catalina.out file is rotated every day

    rotate 7 # Keep at most 7 copies

    missingok # If the file to be rotated is lost, continue to rotate without reporting an error

    compress # Use compression (very useful, save hard disk space; a log file of 2~3GB can be compressed into about 60MB)

    size 16M # When the catalina.out file is larger than 16MB, rotate
}
```

**How does the above work?**

1. The crond daemon will run in the task list in the/etc/cron.daily directory every night;
2. The scripts related to logrotate are also in the/etc/cron.daily directory. The running mode is "/usr/bin/logrotate/etc/logrotate.conf";
3. The/etc/logrotate.conf file includes all the files in the/etc/logrotate.d/directory. It also includes the tomcat file we just created above;
4. The/etc/logrotate.d/tomcat file will trigger the rotation of the/usr/local/apache-tomcat-8.0.28/logs/catalina.out file.

The above is done automatically by the program, without our intervention. Of course, we can also use the manual way to logrotate program. Run the following on the command line:

```
logrotate /etc/logrotate.conf
```

Or just rotate the tomcat configuration file just now, you can run it like this:

```
logrotate --force /etc/logrotate.d/tomcat
```

To get more help information about the logrotate program, you can check its man page,

```
man logrotate
```

You can look at the file size before and after the rotation of catalina.out,

Before rotation:

```
du -sh *
...
2.0G catalina.out # File size before rotation
...
```

File size after rotation:

```
# du -sh catalina.out*
2.0M catalina.out
60M catalina.out.1.gz # After the rotation, compression is performed, and the log file becomes smaller
```

In addition, in the logs directory of Tomcat, a lot of log files are generated every day. We can also delete the log files 7 days ago manually or using a scheduled task. Here we use manual methods to demonstrate.

```
cd /usr/local/apache-tomcat-8.0.28/logs
find -mtime +7 -exec rm -f {} \;
```

Okay, that's it. Hope to help children's shoes in need.



随着项目的运行，Tomcat的日志文件catalina.out的大小日益增大，现在都有好几个GB了。如果我们不做任何处理，catalina.out的文件大小将会持续增加，直到把我们的系统硬盘空间给撑爆不可。

当Tomcat的日志文件catalina.out的大小大于2GB时，Tomcat程序崩溃时将有可能会启动失败并且不会有任何错误信息提示。为了避免该场景的出现，我们要定期轮转catalina.out日志文件。

这里小白使用CentOS6U5自带的logrotate程序来解决catalina.out的日志轮转问题。这种方式比较简单。在/etc/logrotate.d/目录下新建一个名为tomcat的文件，

cat >/etc/logrotate.d/tomcat <<EOF
/usr/local/apache-tomcat-8.0.28/logs/catalina.out{
    copytruncate
    daily
    rotate 7
    missingok
    compress
    size 16M
}
EOF


以上的配置说明：

/usr/local/apache-tomcat-8.0.28/logs/catalina.out{ # 要轮转的文件
    copytruncate # 创建新的catalina.out副本后，截断源catalina.out文件
    daily     # 每天进行catalina.out文件的轮转
    rotate 7   # 至多保留7个副本
    missingok   # 如果要轮转的文件丢失了，继续轮转而不报错
    compress   # 使用压缩的方式（非常有用，节省硬盘空间；一个2~3GB的日志文件可以压缩成60MB左右）
    size 16M   # 当catalina.out文件大于16MB时，就轮转
}


以上是如何工作的呢？

每天晚上crond守护进程会运行在/etc/cron.daily目录中的任务列表；

与logrotate相关的脚本也在/etc/cron.daily目录中。运行的方式为"/usr/bin/logrotate /etc/logrotate.conf"；

/etc/logrotate.conf文件include了/etc/logrotate.d/目录下的所有文件。还包括我们上面刚创建的tomcat文件；

/etc/logrotate.d/tomcat文件会触发/usr/local/apache-tomcat-8.0.28/logs/catalina.out文件的轮转。

以上是程序自动完成的，不需要我们干预。当然了，我们也可以使用手工的方式进行logrotate程序。在命令行进行如下运行：

logrotate /etc/logrotate.conf
1.
或者只轮转刚刚的tomcat配置文件，可以这样运行：

logrotate --force /etc/logrotate.d/tomcat
1.

要想获得logrotate程序的更多帮助信息，可以查看其man page，

man logrotate
1.

可以看一下catalina.out轮转前后的文件大小，

轮转之前：

du -sh *
...
2.0G	catalina.out # 未轮转之前的文件大小
...



轮转之后的文件大小：

du -sh catalina.out*

2.0M	catalina.out
60M	catalina.out.1.gz # 轮转之后，进行压缩，日志文件变得更小了


另外在Tomcat的logs目录，每天都会产生很多日志文件，我们也可以定期手工或使用定时任务来删除7天前的日志文件，这里使用手工的方式进行演示，

cd /usr/local/apache-tomcat-8.0.28/logs
find -mtime +7 -exec rm -f {} \;


好了，就到这里了。希望可以帮到有需要的童鞋。
--------------------------------------------

©著作权归作者所有：来自51CTO博客作者bigstone2012的原创作品，请联系作者获取转载授权，否则将追究法律责任
解决Tomcat日志文件catalina.out文件过大问题
https://blog.51cto.com/lavenliu/1765791
