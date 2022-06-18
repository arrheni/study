#!/bin/bash
q_dir=/home/ap/Incremental/NB_UW

date_dir=`date +%F` ##今日日期
backup_dir=$q_dir/backup/$date_dir/$Version
publish_dir=$q_dir/publish/$date_dir/$Version
#发布包备份路径
test -d  $backup_dir|| mkdir -p $backup_dir
#最终发布包路径
test -d  $publish_dir  || mkdir -p $publish_dir

cp $q_dir/rsync.sh  $publish_dir

function getJar()
{
cat $q_dir/$date_dir/result|while read line
do
scp  jen@10.1.95.50:/home/ap/was/AppServer/profiles/AppSrv01/installedApps/COREPTap1Cell01/local-webapp.ear/local-webapp-521.0.1.war/WEB-INF/lib/$line*.jar      $backup_dir    ##回归环境把包拽下来放到备份文件夹

#scp  jen@10.1.95.50:/home/ap/was/AppServer/profiles/AppSrv01/installedApps/COREPTap1Cell01/local-webapp20190725.ear/local-webapp-521.0.1.war/WEB-INF/lib/$line*.jar      $backup_dir    ##临时分支
echo $line

cp  $backup_dir/$line*.jar  $q_dir/$date_dir/WEB-INF/lib/$line*/  ##把包复制到/home/ap/Incremental/NB_UW/WEB-INF/lib/下
done
}

#制作回归发布包
function MergeCode(){
cat $q_dir/$date_dir/result|while read line
do
cd   $q_dir/$date_dir/WEB-INF/lib/$line*/
array=(com  META-INF)
for var in ${array[@]};
do
ls -l $var > /dev/null 2>&1 #黑洞
if  [ $? -eq  0 ];then
   jar uvfM  $line*.jar  $var   ##合包命令
fi
done
[[ ! -d $publish_dir/NB_UW/WEB-INF/lib ]] && mkdir -p $publish_dir/NB_UW/WEB-INF/lib
cp  $q_dir/$date_dir/WEB-INF/lib/$line*/$line*.jar  $publish_dir/NB_UW/WEB-INF/lib   ##复制最终发布包到/home/ap/Incremental/NB_UW/publish下
done
}
#将回归发布文件上传至FTP服务器
function upPublishDoc(){
cd $publish_dir
ftp_dir="/home/ftpuser/PublishPackage/`date +%Y%m%d`"
wget --ftp-user=ftpuser --ftp-password=user123 --no-proxy ftp://10.1.95.54/PublishPackage/`date +%Y%m%d`/version.txt
Mi_FTP_Version=$(cat version.txt)
scp -r NB_UW  ftpuser@10.1.95.54:$ftp_dir/$Mi_FTP_Version
scp -r NB_UW  ftpuser@10.1.95.54:/home/ap/Incremental/publish_script/jar
}
getJar
MergeCode
upPublishDoc
