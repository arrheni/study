## 前言

新入职公司，发现公司还在使用落后生产工具 svn，由于重度使用过 svn 和 git ，知道这两个工具之间的差异，已经在使用 git 的路上越走越远。

于是，跟上级强烈建议让我在公司推行 git 和他的私有仓库 gitlab，多次安利“磨刀不误砍柴工”的理念，终于被我说服。

以下是我边安装和边记录的详细笔记，务求安装好之后分享给同事直接就能看懂，降低团队的学习成本。

## git的优点

1. git是分布式的，svn不是

   git分布式本地就可以用，可以随便保存各种历史痕迹，不用担心污染服务器，连不上服务器也能提交代码、查看log。
2. GIT分支和SVN的分支不同

   分支在SVN中实际上是版本库中的一份copy，而git一个仓库是一个快照，所以git 切换、合并分支等操作更快速。
3. git有一个强大的代码仓库管理系统 - gitlab

   可以很方便的管理权限、代码review，创建、管理project

## GitLab介绍

GitLab：是一个基于Git实现的在线代码仓库托管软件，你可以用gitlab自己搭建一个类似于Github一样的系统，一般用于在企业、学校等内部网络搭建git私服。

功能：Gitlab 是一个提供代码托管、提交审核和问题跟踪的代码管理平台。对于软件工程质量管理非常重要。

版本：GitLab 分为社区版（CE） 和企业版（EE）。

配置：建议CPU2核，内存2G以上。

#### Gitlab的服务构成：

Nginx：静态web服务器。

gitlab-shell：用于处理Git命令和修改authorized keys列表。（Ruby）

gitlab-workhorse: 轻量级的反向代理服务器。（go）

> GitLab Workhorse是一个敏捷的反向代理。它会处理一些大的HTTP请求，比如文件上传、文件下载、Git push/pull和Git包下载。其它请求会反向代理到GitLab Rails应用，即反向代理给后端的unicorn。

logrotate：日志文件管理工具。

postgresql：数据库。

redis：缓存数据库。

sidekiq：用于在后台执行队列任务（异步执行）。（Ruby）

unicorn：An HTTP server for Rack applications，GitLab Rails应用是托管在这个服务器上面的。（Ruby Web Server,主要使用Ruby编写）

## GitLab安装

#### 1.源码安装

#### 2.yum安装

官方源地址：[https://about.gitlab.com/downloads/#centos6](https://link.jianshu.com?t=https%3A%2F%2Fabout.gitlab.com%2Fdownloads%2F%23centos6)

清华大学镜像源：[https://mirror.tuna.tsinghua.edu.cn/help/gitlab-ce](https://link.jianshu.com?t=https%3A%2F%2Fmirror.tuna.tsinghua.edu.cn%2Fhelp%2Fgitlab-ce)

#### 新建 /etc/yum.repos.d/gitlab_gitlab-ce.repo，内容为：

#### 安装依赖

#### 再执行

#### 配置域名： vim /var/opt/gitlab/nginx/conf/gitlab-http.conf

补充说明：因为编译gitlab的配置 /etc/gitlab/gitlab.rb 时会重新生成这个自定义nginx 配置，所以只要 gitlab 的配置配得好，上面的nginx其实不需要自定义的。

## 修改密码

## GitLab备份和恢复

#### 备份

备份的数据会存储在/var/opt/gitlab/backups，用户通过自定义参数 gitlab_rails['backup_path']，改变默认值。

#### 恢复

## GitLab配置文件修改

#### gitlab基本配置:

#### gitlab发送邮件配置

#### 服务器修改过ssh端口的坑(需要修改配置ssh端口)

#### 配置生效

## GitLab常用命令

#### 注意：执行 reconfigure 命令会把gitlab的nginx组件的配置还原，导致自定义修改的端口以及域名等都没有了。

## 常用目录

## 查看gitlab版本

cat /opt/gitlab/embedded/service/gitlab-rails/VERSION

## 新建项目

使用root用户登录进gitlab会后，点击“new project“创建一个项目，比如项目命名为“kuaijiFirstProject”。

然后会发现，硬盘上已经生成了一个git文件：

## 汉化

[https://gitlab.com/xhang/gitlab.git](https://link.jianshu.com?t=https%3A%2F%2Fgitlab.com%2Fxhang%2Fgitlab.git)

## gitlab的使用

注意：`<fornt style="color:red">`以上这条 ssh 命令测试通过，未必代表就能 git clone 代码，git clone 代码需要执行命令的账户有写权限，如果是普通用户用 sudo git clone 那么 git 就会使用的 root 账号的 Private Key。 `</fornt>`

#### 1.登录

管理员会为使用者开通账号并设置权限。

#### 2.使用者在客户端生成ssh key

参考文章： [http://www.jianshu.com/p/142b3dc8ae15](https://www.jianshu.com/p/142b3dc8ae15)

#### 3.将公钥的内容copy到gitlab用户设置里面的“SSH Keys”

Windows:  clip < ~/.ssh/id_rsa.pub

Mac:  pbcopy < ~/.ssh/id_rsa.pub

GNU/Linux (requires xclip):  xclip -sel clip < ~/.ssh/id_rsa.pub

#### 4.测试ssh连接

如果连接成功的话，会出现以下信息:

说明：实际上执行这条ssh命令，所使用的远程服务器的用户是git，这个用户是在安装gitlab的时候生成的，所有使用gitlab服务器的ssh客户端，都是使用git这个用户。在这里的用户“huangdc”是通过gitlab创建的，是用于gitlab的权限管理，也用作标识提交代码的开发者信息，不要跟ssh的用户混淆了。

## 如何使用多个SSH公钥（自己电脑在使用多个代码仓库）

原理其实是：因为每个仓库都需要 ssh 连接，而 ssh 命令默认是使用 .ssh 目录下面的私钥去连接代码仓库，所以我们可以在 .ssh/config 目录里面针对不同的仓库域名重定义它的私钥。

##### 例子如下：

编辑文件: vim /Users/david/.ssh/config

## 命令行环境下初始化项目

1. 首先在 gitlab 上面创建一个空的代码仓库，得到仓库地址如下：
2. 在本地初始化仓库、提交代码、推送到远程 master 分支。

## 命令行环境下迁移旧的项目

1. 首先在 gitlab 上面创建一个空的代码仓库，得到仓库地址如下：
2. 本地初始化项目、关联远程仓库、推送到远程仓库

## SourceTree的安装和打开

1. 官网下载链接：[https://www.sourcetreeapp.com/](https://link.jianshu.com?t=https%3A%2F%2Fwww.sourcetreeapp.com%2F)
2. 打开SourceTree之后，需要登录Atlassian账号来激活SourceTree。可以使用Google账号直接关联登录。
3. 登录后还需要一些设置，以最简单的方式跳过就行。

## Git Flow

[http://flc.ren/2015/12/381.html](https://link.jianshu.com?t=http%3A%2F%2Fflc.ren%2F2015%2F12%2F381.html)

### 备注

这篇文章主要记录如何安装和使用 GitLab ，晚点再分享一篇讲解分支模型策略的文章。





问题描述
按照官方教程GitLab Installation一步步操作下来，成功下载和安装了GitLab，相关配置也改了，external_url改成了服务器的ip和开放的端口号，端口号在防火墙上也开了，但是在服务器上访问时却报了502错误，如下图所示

网上找了很多方案，有的说是服务器内存不够要提高配置，但是我的服务器配置是可以的，应该不是这个问题

有的说是要修改/etc/gitlab/gitlab.rb文件如下配置的超时时间，改长一点，还是没用。而且我出现这个错误是秒出现的，而不是在等待一段时间后出现的，所以也不是超时的问题

unicorn['worker_processes'] = 3
unicorn['worker_timeout'] = 60
gitlab_rails['webhook_timeout'] = 90
gitlab_rails['git_timeout']=90
 解决方案
折腾了好久，最后终于找到了解决的方法

1.首先vim  /etc/gitlab/gitlab.rb打开配置文件

2.修改配置

找到如下配置项，原来是用#注释的，把前面的#去掉取消注释，原来的默认端口号应该是8080，改成你自己想要的端口号，比如8099

注意新配置的端口号不要被其他进程占用，且要在防火墙设置放开

以下两项新配置的端口号需一致

之所以报502这个错误就是原来默认配置的8080端口号被其他应用占用冲突了，只需换成其他新的端口号就可以了

unicorn['port'] = 8099
gitlab_workhorse['auth_backend'] = "http://localhost:8099"
3.输入如下命令让配置生效

sudo gitlab-ctl reconfigure
4.最后重启服务

sudo gitlab-ctl restart
因为重启服务后刷新可能不能马上成功，差不多要等个一分钟左右再重新刷新页面就成功了，如下图所示，完美
