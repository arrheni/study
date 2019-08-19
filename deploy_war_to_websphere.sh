earfile=`ls ${WORKSPACE}/local-webapp/target/*.war|xargs basename`
node=`echo ${NODE_LABELS}`
if [ $node == "master" ];then
/home/ap/was/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${WORKSPACE}'/local-webapp/target/'$earfile' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/GLOBALJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/PAJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'

elif [ $node == "98.9" ];then
/home/fb/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${WORKSPACE}'/local-webapp/target/'$earfile' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/GLOBALJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/PAJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'
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
