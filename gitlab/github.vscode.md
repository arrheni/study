## [vscode配置git和提交代码到github教程](https://www.cnblogs.com/ExMan/p/15078590.html)

**用了git最方便的就是比如在公司写了很多代码后回到家打开vscode只需要点击一下pull就能全部同步过来。是不是很方便。。。。毕竟之前我都是拿u盘拷贝回家或者存到云盘再下载下来。。**

我这里用的是国内的码云托管的代码，，github都是英文看不懂。。

因为vscode中带的有git管理功能，只需要学一点关于git的操作知识就够了。

首页要下载‘msysgit’然后安装到电脑要不然vscode中的git是不能用的。安装完成后主要使用Git Bash这个程序来操作

1、将代码放到码云

* 到码云里新建一个仓库，完成后码云会有一个命令教程按上面的来就行了
* 码云中的使用教程：

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

```
Git 全局设置:

git config --global user.name "ASxx" 
git config --global user.email "123456789@qq.com"

创建 git 仓库:

mkdir wap
cd wap
git init
touch README.md
git add README.md
git commit -m "first commit"
git remote add origin https://git.oschina.net/name/package.git
git push -u origin master
已有项目?

cd existing_git_repo
git remote add origin https://git.oschina.net/name/package.git
git push -u origin master
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

**下面说下详细的本地操作步骤：**

* **1、用vs打开你的项目文件夹**

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201153132662-586980552.png)

* **2、配置git**

　　打开Git Bash输入以下命令

　　如果还没输入全局配置就先把这个全局配置输入上去

```
Git 全局设置:

git config --global user.name "ASxx" 
git config --global user.email "123456789@qq.com"
```

　　然后开始做提交代码到码云的配置

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

```
cd d:/wamp/www/mall360/wap              //首先指定到你的项目目录下
```

```
git init
touch README.md
git add README.md
git commit -m "first commit"
git remote add origin https://git.oschina.net/name/package.git   //用你仓库的url
git push -u origin master  //提交到你的仓库
```

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

[![复制代码](https://common.cnblogs.com/images/copycode.gif)]()

[![复制代码](https://common.cnblogs.com/images/copycode.gif)](javascript:void(0); "复制代码")

　　正常情况下上面的命令执行完成后，本地文件夹会有一个隐藏的.git文件夹，云端你的仓库里应该会有一个README.md文件。

* **3、在vscode中提交代码到仓库**

　　回到vs code打开git工作区就会看到所有代码显示在这里

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201154814834-1134939768.png)

点击+号，把所有文件提交到暂存区。

然后打开菜单选择--提交已暂存的

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201155023724-1322104252.png)

然后按提示随便在消息框里输入一个消息，再按ctrl+enter提交

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201155202834-327778020.png)

然后把所有暂存的代码push云端，

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201160939146-982866213.png)

点击后，会弹出让你输入账号密码，把你托管平台的账号密码输入上去就行了。。。

不出问题的话你整个项目就会提交到云端上了。

在vs中每次更新代码都会要输入账号密码，方便起见，可以配置一下让GIT记住密码账号。

```
git config --global credential.helper store   //在Git Bash输入这个命令就可以了
```

* **4、同步代码**

**　　这里说下平时修改代码后提交到云端的使用，和本地代码和云端同步**

　　随便打开一个文件，添加一个注释

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201162825334-679253344.png)

可以看到git图标有一个提示，打开git工作区可以看到就是修改的这个文件

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201162929693-967877373.png)

然后点击右侧的+号，把他暂存起来。

再在消息框里输入消息，按ctrl+enter提交暂存

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201163128349-1615861863.png)

再点击push提交，代码就提交到云端了。

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201163237740-1822824997.png)

打开 码云就可以看到了。。

 ![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201163513818-1334704517.png)

* pull使用

　　比如当你在家里修改了代码提交到云端后，回到公司只需要用vscode打开项目点击菜单中的pull就可以同步过来了。

 ![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201163904974-425665535.png)

* **5、克隆你的项目到本地**

　　回到家后想修改代码，但是电脑没有文件怎么办呢？  往下看

　　首先你电脑还是的有vscode 和  GIT，，然后用git把上面那些全局配置再执行一次，如下

```
git config --global user.name "ASxx"
git config --global user.email "123456789@qq.com"  

git config --global credential.helper store  
```

　　然后打开Git Bash输入以下命令

```
cd d:/test   //指定存放的目录
git clone https://git.oschina.net/name/test.git   //你的仓库地址
```

![](https://images2015.cnblogs.com/blog/717286/201612/717286-20161201165048943-1663566323.png)

下载成功，然后就可以用vscode打开项目修改了，修改后提交的步骤还是和上面一样：暂存-提交暂存-push提交到云端就ok了。





# git提交时遇到push declined due to email privacy restrictions(GH007: Your push would publish a private email address)的解决方法


每次重装系统后都会忘掉，记下来

重装系统＆配置好ssh密钥后，git提交更改会遇到如下问题

```
remote: error: GH007: Your push would publish a private email address.
remote: You can make your email public or disable this protection by visiting:
remote: http://github.com/settings/emails
To github.com:000000000000/hkytheater.git
 ! [remote rejected] master -> master (push declined due to email privacy restrictions)
error: failed to push some refs to 'git@github.com:0000000/hkytheater.git'
```

原因是习惯性把 `git config --global user.email`设置成了github邮箱，而我们又设置了邮箱隐私，因此必须提交到github提供的noreply.github.com邮箱。
这里有两种不同的选择：一是直接取消该设置，或更改提交到的邮箱地址。配置页面均为[https://github.com/settings/emails](https://github.com/settings/emails) 。

### 取消邮箱隐私设置（可能会暴露真实邮箱）

找到 **Block command line pushes that expose my email** ，取消勾选前方复选框即可，如下图。

[![email settings](https://hky.moe/img/191201.png "email settings")](https://hky.moe/img/191201.png)

email settings

### 使用隐私邮箱进行更改提交

如上图，找到 **Keep my email addresses private** ，可以提交的邮箱即为下方小字加粗的邮箱地址。在git bash中执行 `git config --global user.email "隐私邮箱地址"` 即可。

在git中更改邮箱后，有时仍然会出现提交失败的情况，此时需要刷新一下提交者信息

```
 git commit --amend --reset-author
```

该命令会自动提交当前已经进行的修改，在此之后就可以正常提交了。
