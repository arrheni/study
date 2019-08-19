#!/bin/bash

echo AP1 pa clm cap

host="10.1.95.47"
soapport="8883"
username="wasadmin"
password="~~~~~~"
ap1_appname="local-webapp-0_5_5_2_war"
contextroot="ls"
name_key="AP2*PA_CLM_CAP.ear"

AppSrv="AppSrv02"
app_path="/home/ap/was/AppServer/profiles/${AppSrv}"
wsadmin=${app_path}/bin/wsadmin.sh
ear_path="${app_path}/logs/"
ear_file=`find ${ear_path} -name ${name_key} -a -mtime -1 | sort -r | head -1 `


update_ap1() {
    earfile=`basename ${ear_file}`
	echo "update AP1 from AP2 ${ear_file}"	
	#${wsadmin} -host ${host} -port ${soapport}  -user $username -password $password -c '$AdminApp update '$ap1_appname' app  {-operation update -contents '${ear_file}' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/UdmpJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/UdmpDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'
	echo ${wsadmin} -lang jython -host ${host} -port ${soapport}  -user $username -password $password -c "AdminApplication.updateApplicationUsingDefaultMerge("${ap1_appname}", "${ear_file}")"
    time ${wsadmin} -lang jython -host ${host} -port ${soapport}  -user $username -password $password -c "AdminApplication.updateApplicationUsingDefaultMerge(\"${ap1_appname}\", \"${ear_file}\")"
    ls -lrth ../../AppSrv04/installedApps/qrytap0Node04Cell/local-webapp-0_5_5_2_war.ear/local-webapp-0.5.5.3.war/WEB-INF/lib/ | tail
}

if [ -f "${ear_file}" ];then
echo ==== use ear file === $ear_file
	update_ap1
else
	echo "there is no ear file in ${ear_path}"
	exit
fi

old_ear_file=`find $ear_path  -name  "*.ear" -a -mtime +30 | tr '\n' ' ' `
if [ -n "$old_ear_file" ]

then 
    echo "rm $old_ear_file"
    rm -v $old_ear_file
fi
