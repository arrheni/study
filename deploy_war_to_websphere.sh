#!/bin/bash

d=$(date +%F)
#d="2019-08-14"

base_path="${WORKSPACE}"
mother_path="$base_path/local-webapp/target/local-webapp-0.5.4/"
war_file="local-webapp-0.5.4.war"
jar_list="nb-interface nb-impl nb-web uw-interface uw-impl uw-web pa-interface  clm-interface  cap-interface  css-interface   prd-interface  prd-impl  commonbiz-interface  commonbiz-impl  commonbiz-web  fms-biz"

META_resources="nb uw common"

#########################################################################################################
backup_path="${base_path}/Backup/$d/"
from_path="WEB-INF/lib/"
to_class_path="WEB-INF/classes/"
META_resources_path="WEB-INF/classes/META-INF/resources/"
webapp="src/main/webapp/"
resources="src/main/resources/"
java="src/main/java/"

#########################################################################################################
function clean_path()
{
        if [ -d $backup_path ] 
	    then
		    rm -rf ${backup_path}*
	    else
		    mkdir -p $backup_path
	    fi
}

############################## unzip war or jar  #########################################################
function unzip_jar()
{
	for jar in ${jar_list}
	do
		unzip_jar=`ls ${mother_path}${from_path}${jar}*`
		unzip -qo  ${unzip_jar}  -d ${mother_path}${to_class_path}
		mv ${unzip_jar}  ${backup_path}
	done
	
	for mr in $META_resources
	do
	        cp -r ${mother_path}${META_resources_path}${mr}  ${mother_path}
	        rm -r ${mother_path}${META_resources_path}${mr}
	done
}


############################## zip  jar .war ############################################################
function zip_war_file()
{
	cd $mother_path
	jar -cfM0 $war_file  ./
	mv $war_file $backup_path
	cd $base_path
	find Backup/ -maxdepth 1 -mindepth 1 -type d -mtime 7 -exec rm -rfv "{}" \
}

clean_path
unzip_jar
zip_war_file

##########################################################################################################



earfile=`ls ${WORKSPACE}/local-webapp/target/*.war|xargs basename`
node=`echo ${NODE_LABELS}`
if [ $node == "master" ];then
/home/ap/was/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${WORKSPACE}'/local-webapp/target/'$earfile' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/UdmpJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/UdmpDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'
elif [ $node == "98.9" ];then
#time /home/fb/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${backup_path}${war_file}' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/UdmpJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/UdmpDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'
whoami
#time /home/fb/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${WORKSPACE}'/local-webapp/target/'$earfile' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/UdmpJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/UdmpDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'
fi








sleep 120
dir="/home/ap/was/AppServer/profiles/AppSrv02/config/cells/COREPTap0Node01Cell/applications/local-webapp1657a8a2050.ear/deployments/local-webapp1657a8a2050"

loaderStatus=$(grep 'classloaderMode="PARENT_FIRST"'  $dir/deployment.xml)
echo "类加载顺序为PARENT_FIRST?====$loaderStatus"
loaderStatus1=$(grep 'classloaderMode="PARENT_LAST"'  $dir/deployment.xml)
echo "类加载顺序为PARENT_LAST?=====$loaderStatus1"

#类加载顺序不为PARENT_LAST和PARENT_FIRST时
if [ -z "$loaderStatus" ] && [ -z "$loaderStatus1" ];then
echo  "===========类加载顺序不为PARENT_LAST和PARENT_FIRST时========="
row=$(grep -n "appdeployment:WebModuleDeployment" $dir/deployment.xml|awk -F  ':'  '{print $1}')
sed -i $row's/containsEJBContent="0"/classloaderMode="PARENT_LAST" containsEJBContent="0"/'  $dir/deployment.xml 
pid=`ps -ef|grep server1|grep AppSrv02|grep -v grep|awk '{print $2}' `   &&  kill -9  $pid 
sh /home/ap/was/AppServer/profiles/AppSrv02/bin/startServer.sh server1 

#类加载顺序为PARENT_FIRST 时
elif  [ ! -z  "$loaderStatus" ] ;then
echo  "===========类加载顺序为PARENT_FIRST 时=========="
sed -i 's/classloaderMode="PARENT_FIRST"/classloaderMode="PARENT_LAST"/'   `grep "classloaderMode="PARENT_FIRST""  -rl   $dir/deployment.xml`  $dir/deployment.xml 
pid=`ps -ef|grep server1|grep AppSrv02|grep -v grep|awk '{print $2}' `   &&  kill -9  $pid 
sh  /home/ap/was/AppServer/profiles/AppSrv02/bin/startServer.sh server1 

fi
