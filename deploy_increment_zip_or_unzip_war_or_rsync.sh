#!/bin/bash

blue="\033[0;36m"
red="\033[0;31m"
green="\033[0;32m"
close="\033[m"

d=$(date +%F)

echo -e  "--------------- must para 1 system in (  $green qry nb pa css jrqd $close)--------------------------"
echo -e  "----------------must para 2 deploy in (  $green ql cbql cbzl       $close)--------------------------"
echo -e  "-------------------------- may para 3 the day before today to update -------------------------------"

if [ -z "$1" -a -z "$2" ] ;then 

	echo  -e "use the paragram need para $red at least 2 $close  in  qry nb pa css "
	
	exit 1
	
fi

system=$1
deploy=$2
day=$3

# svn log start_date <= svn log file  < end_date   st='2019-9-6T11:00'
st="$(date +%F -d "$day days ago")T11:00"

# end_time   et="$(date +%F)T12:00"
et="$(date +%FT%R)"

#base_path=`pwd`
base_path="${WORKSPACE}"

case $system in

    qry)
		
		mother_path="${base_path}/qry-web/target/qry-web/"
		
		war_file="qry-web.war"
		
		jar_list="nb-interface  uw-interface  pa-interface  clm-interface  cap-interface  css-interface  qry-interface  qry-impl  prd-interface  prd-impl  commonbiz-interface  commonbiz-impl  commonbiz-web  fms-biz"
		
		META_resources="common"
		
		cat >svn_url <<EOF
https://10.1.40.2/svn/P102_CBO/02Test/tag/NB-UW/            || nb-interface  | uw-interface
https://10.1.40.2/svn/P108_CAP/02Test/tag/CLM_CAP/          || pa-interface  | clm-interface  | cap-interface 
https://10.1.40.2/svn/P105_CSS/02Test/trunk/code/css/       || css-interface 
https://10.1.40.2/svn/P111_COB/01Dev/trunk/code/commonbiz/  || commonbiz-interface | commonbiz-impl  | commonbiz-web
https://10.1.40.2/svn/P105_CSS/02Test/trunk/code/qry/       || qry-interface       | qry-impl          |  qry-web
https://10.1.40.2/svn/P102_CBS/02Test/trunk/code/prd/       || prd-interface       | prd-impl
https://10.1.40.2/svn/P102_CBS/01Dev/trunk/code/fms/        || fms-biz
EOF

    ;;
	
    nb)
	
		mother_path="$base_path/local-webapp/target/local-webapp-0.5.4/"
		
		war_file="local-webapp-0.5.4.war"
		
		jar_list="nb-interface nb-impl nb-web uw-interface uw-impl uw-web pa-interface  clm-interface cap-interface  css-interface  prd-interface  prd-impl commonbiz-interface  commonbiz-impl commonbiz-web  fms-biz"
		
		META_resources="nb  uw  common"
		
		cat >svn_url <<EOF
https://10.1.40.2/svn/P102_CBO/02Test/tag/NB-UW/            || nb-interface  | nb-impl        |nb-web         | uw-interface    |uw-impl    | uw-web
https://10.1.40.2/svn/P108_CAP/02Test/tag/CLM_CAP/          || pa-interface  | clm-interface  | cap-interface 
https://10.1.40.2/svn/P105_CSS/02Test/trunk/code/css/       || css-interface 
https://10.1.40.2/svn/P111_COB/01Dev/trunk/code/commonbiz/  || commonbiz-interface | commonbiz-impl  | commonbiz-web
https://10.1.40.2/svn/P102_CBS/02Test/trunk/code/prd/       || prd-interface       | prd-impl
https://10.1.40.2/svn/P102_CBS/01Dev/trunk/code/fms/        || fms-biz
EOF

    ;;
	
    pa)
		#编译完成的应用目录
		mother_path="$base_path/local-webapp/target/local-webapp-0.5.5.3/"
		
		#编译生成的war包名称
		war_file="local-webapp-0.5.5.3.war"
		
		#需要解压缩的jar包前缀
		jar_list="nb-interface uw-interface pa-interface pa-impl pa-web clm-interface clm-impl clm-web cap-interface cap-impl cap-web css-interface prd-interface prd-impl commonbiz-interface commonbiz-impl commonbiz-web fms-biz"
		
		#需要从META resources移除的目录
		META_resources="pa cs clm cap common mobcss images"
		
		cat >svn_url <<EOF
https://10.1.40.2/svn/P102_CBO/02Test/tag/NB-UW/            || nb-interface  | uw-interface
https://10.1.40.2/svn/P108_CAP/02Test/tag/CLM_CAP/          || pa-interface  |pa-impl |pa-web | clm-interface| clm-impl |clm-web | cap-interface |cap-impl |cap-web
https://10.1.40.2/svn/P105_CSS/02Test/trunk/code/css/       || css-interface 
https://10.1.40.2/svn/P111_COB/01Dev/trunk/code/commonbiz/  || commonbiz-interface | commonbiz-impl  | commonbiz-web
https://10.1.40.2/svn/P102_CBS/02Test/trunk/code/prd/       || prd-interface       | prd-impl
https://10.1.40.2/svn/P102_CBS/01Dev/trunk/code/fms/        || fms-biz
EOF


#svn_url="https://10.1.40.2/svn/P102_CBO/02Test/tag/NB-UW/            || nb-interface  | uw-interface
#https://10.1.40.2/svn/P108_CAP/02Test/tag/CLM_CAP/          || pa-interface  |pa-impl |pa-web | clm-interface| clm-impl |clm-web | cap-interface |cap-impl |cap-web
#https://10.1.40.2/svn/P105_CSS/02Test/trunk/code/css/       || css-interface 
#https://10.1.40.2/svn/P111_COB/01Dev/trunk/code/commonbiz/  || commonbiz-interface | commonbiz-impl  | commonbiz-web
#https://10.1.40.2/svn/P102_CBS/02Test/trunk/code/prd/       || prd-interface       | prd-impl
#https://10.1.40.2/svn/P102_CBS/01Dev/trunk/code/fms/        || fms-biz"

    ;;
	
	css)
	
	;;
	*)
        echo -e  " $red Input error!!  $close only support ( qry nb pa css ) system to update  $red----EXIT----$close "
		
		exit 1
    ;;
esac




#########################################################################################################
#增量文件列表，svn 生成
svn_update_list="svn_update_list_$system_$d.txt"
		
#生成的增量zip包
increment_zip="increment_$system_$d.zip"

backup_path="${base_path}/Backup/$d/"
rsync_path="${backup_path}Rsync/"

update_file_list="update_file_list_$d.txt"
java_list="java_list_$d.txt"

from_path="WEB-INF/lib/"
to_class_path="WEB-INF/classes/"
META_resources_path="WEB-INF/classes/META-INF/resources/"

webapp="src/main/webapp/"
resources="src/main/resources/"
java="src/main/java/"




function clean_backup_path(){

	find Backup/ -maxdepth 1 -mindepth 1 -type d -mtime +7 -exec rm -rf "{}" \;
	
	if [ -d ${backup_path} ]; then
	
		rm -rf ${backup_path}*

	else
	
		mkdir -p ${backup_path}
	
	fi
	
}

function unzip_jar() {

	for jar in ${jar_list}; do
	
		unzip_jar=$(ls ${mother_path}${from_path}${jar}*)
		
		unzip -qo ${unzip_jar} -d ${mother_path}${to_class_path}
		
		mv ${unzip_jar} ${backup_path}
		
	done

	for mr in ${META_resources}; do
	
		cp -r ${mother_path}${META_resources_path}${mr} ${mother_path}
		
		rm -r ${mother_path}${META_resources_path}${mr}
		
	done

}


function get_unjar_full_war_file() {

	cd ${mother_path}
	
	jar -cfM0 ${war_file} ./
	
	mv ${war_file} ${backup_path}
	
	cd ${base_path}
	
}

function get_svn_update_list() {

	echo -e  "-----get svn update file list from  $red  $st  $close to $green $et   $close  svn change file is   $blue  ${svn_update_list}  $close -----"

	cat /dev/null >${svn_update_list}
	
	#echo "$svn_url"| sed 's/[[:space:]]//g' | while read line;do
	cat svn_url | sed 's/[[:space:]]//g' | while read line; do
	
		url=${line%||*}
		
		key_words=${line#*||}

		svn diff -r {$st}:{$et} $url --summarize | awk -F $url '/.+[.][^./]+$/ {if($1=="D       ") {print $1 $2} else{print $1  $2}}' | grep -E "$key_words" | tee -a ${svn_update_list}

	done
	
}

function get_uncheck_list(){

		grep "$webapp" $1 | awk -F "$webapp" '{print $2}' >$2
		
		grep "$resources" $1 | awk -F "$resources" '{print "WEB-INF/classes/" $2}' >>$2
		
		grep "$java" $1 | awk -F "$java" '{print "WEB-INF/classes/" $2}' >>$3

}

function get_check_list() {

	for mr in ${META_resources}; do
	
		sed -i "s#${META_resources_path}${mr}#${mr}#g" $1
		
	done

}


function get_delete_file_list() {

	grep "D       " ${svn_update_list} | tee ibm-partialapp-delete

	if [ -s ibm-partialapp-delete ]; then
	
		echo  -e "-------------------------there is $red deleted files  $close ABOVE------------------------------------"

		sed -i.bak "/D       /d" ${svn_update_list}
		
		get_uncheck_list ibm-partialapp-delete ibm-partialapp-delete.props ibm-partialapp-delete.props

		sed -i "s/\.java/\.class/g" ibm-partialapp-delete.props
		
		###有bug，若删除的java有内部类,则需从未删除(上一天)的war中获取，不想写了。


		get_check_list ibm-partialapp-delete.props

		cp ibm-partialapp-delete.props ${mother_path}META-INF
		
	fi
	
	rm ibm-partialapp-delete

}

function get_add_or_update_file_list() {

	get_uncheck_list ${svn_update_list} ${update_file_list} ${java_list}

	cd ${mother_path}
	
	awk -F "[.]" '{system("ls " $1 ".class")}{system("ls " $1 "\\$*.class")}' ${base_path}/${java_list} >>${base_path}/${update_file_list}

	cd ${base_path}
	
	get_check_list ${update_file_list}
	
	if [ -s ibm-partialapp-delete.props ]; then
	
		wc ibm-partialapp-delete.props
		
		echo "META-INF/ibm-partialapp-delete.props" >>${update_file_list}
		
		mv ibm-partialapp-delete.props ${backup_path}
		
	fi

	rm ${java_list}
	
	wc ${svn_update_list}*  ${update_file_list}

	echo  -e "------------------ $red check the files numbers  $close ----------------------"
	
	grep '\$' ${update_file_list}
	
}

function get_today_jar_in_update_file_list(){

    cd $mother_path
	
	find WEB-INF/lib/* -mtime 0 >> ${base_path}/${update_file_list}

    cd ${base_path}

}

function rsync_update_file() {

	mkdir -p ${rsync_path}

	rsync --files-from=${update_file_list} ${mother_path} ${rsync_path}${war_file}

	mv ${svn_update_list}*   ${update_file_list} ${backup_path}

}

function get_update_zip_file() {

	cd ${rsync_path}
	
	[ -f ${increment_zip} ] && rm -v ${increment_zip}
	
	zip -qr ${increment_zip} ./
	
	mv ${increment_zip} ${backup_path}
	
	cd ${base_path}
	
}

function deploy(){

	if [ ${NODE_LABELS} == "master" ]; then
	
		wasadmin="/home/ap/was/AppServer/profiles/AppSrv01/bin/wsadmin.sh"
	
	elif [ ${NODE_LABELS} == "98.9" ]; then
	
		wasadmin="/home/fb/AppServer/profiles/AppSrv01/bin/wsadmin.sh"
	
	fi

    case $1 in
	
		#全量部署 
        ql)
            time $wasadmin -host $host -port $port   -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '$mother_path'/../'$war_file' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$war_file' .* '$war_file',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/UdmpJndiDataSource}{'$war_file' .* '$war_file',WEB-INF/web.xml jdbc/UdmpDataSource   javax.sql.DataSource jdbc/UdmpDataSource  }{'$war_file' .* '$war_file',WEB-INF/web.xml jdbc/UdmpCommonDataSource  javax.sql.DataSource jdbc/UdmpCommonDataSource }}}'
        ;;
		
		#拆包全量部署 
        cbql)
             time $wasadmin -host $host -port $port  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${backup_path}${war_file}' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$war_file' .* '$war_file',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/UdmpJndiDataSource}{'$war_file' .* '$war_file',WEB-INF/web.xml jdbc/UdmpDataSource   javax.sql.DataSource jdbc/UdmpDataSource  }{'$war_file' .* '$war_file',WEB-INF/web.xml jdbc/UdmpCommonDataSource  javax.sql.DataSource jdbc/UdmpCommonDataSource }}}'
        ;;
		
		#拆包增量部署 
        cbzl)
            if [ -s ${backup_path}${increment_zip} ] ; then 
				time $wasadmin  -host $host -port $port  -user $username -password $password -c '$AdminApp update  '$appname' partialapp {-contents  '${backup_path}${increment_zip}'}'
			else
				echo -e " $red ERR ,there is no $increment_zip -------------"
			fi
        ;;
        *)
            echo "Input  error!!"
        ;;
    esac

}


clean_backup_path

unzip_jar

get_unjar_full_war_file

get_svn_update_list

if [ -s ${svn_update_list} ]; then

	get_delete_file_list
	
	get_add_or_update_file_list
	
	get_today_jar_in_update_file_list
	
	rsync_update_file
	
	get_update_zip_file
	
else

	echo  -e "------------------------------ $red There must be a list file path in ${svn_update_list} $close-------------------------------"
	
fi

deploy $deploy

