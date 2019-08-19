#!/bin/bash

d=$(date +%F)
#d="2019-08-14"

mother_path="/home/fb/jenkins/workspace/Deploy_Cluster_AP2_QRY_97.47_AppSrv03/qry-web/target/qry-web/"
base_path="/home/fb/jenkins/workspace/Deploy_Cluster_AP2_QRY_97.47_AppSrv03/"
text_path="${base_path}qry/$d/"
rsync_path="${text_path}qry-web/"
#war_path="${base_path}/qry-web/target/"
remote_path='was@10.1.95.47:/home/ap/was/AppServer/profiles/AppSrv03/installedApps/qrytap0Node03Cell/qry-web.ear/qry-web.war/'

#########################################################################################################
from_path="WEB-INF/lib/"
to_class_path="WEB-INF/classes/"
to_META_path="WEB-INF/classes/META-INF/"
to_webapp_path=""

function clean_path()
{
if [ -d $text_path ] 
then
	rm -rf ${text_path}*
else
	mkdir -p $text_path
fi
}

############################## check svn delete files. need list_qry_$d.txt
function check_del_file()
{
grep "D       " list_qry_$d.txt | tee delete_list_$d.txt

if ( [ -s delete_list_$d.txt ] )
then
	echo "there is deleted files ABOVE-----------------------------------------------------"
	echo "---------------------------------------------------------------------------------"
	sed -i.bak "/D       /d" list_qry_$d.txt
fi
}

############################## unzip war & jar.   need svn_jar.txt
function unzip_jar()
{
#unzip -qo ${war_path}qry-web.war -d ${war_path}qry-web
cat svn_jar.txt|while read line
do
	unzip_jar=`ls ${mother_path}${from_path}${line}*`
	unzip -qo  ${unzip_jar}  -d ${mother_path}${to_class_path}
	mv ${unzip_jar}  ${text_path}
done
}

############################## get file copy list

webapp="src/main/webapp/"
resources="src/main/resources/"
java="src/main/java/"
function get_and_check_cp_list()
{
grep "$webapp" list_qry_$d.txt | awk -F "$webapp" '{print $2}' | tee  cp_$d.txt
grep "$resources" list_qry_$d.txt | awk -F "$resources" '{print "WEB-INF/classes/" $2}' | tee -a cp_$d.txt
grep "$java" list_qry_$d.txt | awk -F "$java" '{print "WEB-INF/classes/" $2}' > cp_java_$d.txt
sed "s/\.java/\.class/g" cp_java_$d.txt >> cp_$d.txt

cd $mother_path
awk -F "[.]" '{system("ls " $1 "*.class")}'  ${base_path}cp_java_$d.txt  | grep '\$' | tee -a  ${base_path}cp_$d.txt

cd $base_path
wc list_qry_$d.txt delete_list_$d.txt cp_java_$d.txt  cp_$d.txt 

}

############################## rsync xml js jsp class to rsync_path
function rsync_file()
{
mkdir -p $rsync_path
rsync --files-from=cp_$d.txt $mother_path $rsync_path 

mv list_qry_$d.txt delete_list_$d.txt cp_java_$d.txt  cp_$d.txt $text_path
}

############################## zip increment file to .zip and jar .war 
function zip_and_jar_file()
{
cd $rsync_path
[ -f qry-web_increment_$d.zip ] && rm qry-web_increment_$d.zip
zip -qr qry-web_increment_$d.zip  ./ 
mv qry-web_increment_$d.zip $text_path
cd $mother_path
jar -cfM0 qry-web.war ./
mv qry-web.war $text_path
}

############################## deploy zip or war
function deploy()
{
cd $text_path

rsync --files-from=cp_$d.txt $rsync_path $remote_path

}

if  [  -f list_qry_$d.txt ]
then
    clean_path
    check_del_file
    unzip_jar
    get_and_check_cp_list
    rsync_file
    zip_and_jar_file
else
  echo "NEED file  list_qry_$d.txt  ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--"
fi