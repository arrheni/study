#!/bin/bash

d=$(date +%F)
#d="2019-08-15"
base_path="${WORKSPACE}"

#jenkins 编译完成之后的应用目录
mother_path="$base_path/local-webapp/target/local-webapp-0.5.5.3/"

#编译生成的war包名称
war_file="local-webapp-0.5.5.3.war"

#需提供的增量文件列表，格式有要求(java xml js jsp)
list_file="list_pa_$d.txt"

#生成的增量zip包
increment_zip="increment_pa_$d.zip"

#需要解压缩的jar包前缀
jar_list="nb-interface uw-interface pa-interface pa-impl pa-web clm-interface clm-impl clm-web cap-interface cap-impl cap-web css-interface prd-interface prd-impl commonbiz-interface commonbiz-impl commonbiz-web fms-biz"

#需要从resources移除的目录
META_resources="pa cs clm cap common mobcss images"

######################################以上变量名称需要针对不同环境修改#############################################
backup_path="${base_path}/Backup/$d/"
rsync_path="${backup_path}Rsync/"

#生成的增量列表文件(class xml js jsp)
update_list="update_list_$d.txt"
java_list="java_list_$d.txt"
from_path="WEB-INF/lib/"
to_class_path="WEB-INF/classes/"
META_resources_path="WEB-INF/classes/META-INF/resources/"
webapp="src/main/webapp/"
resources="src/main/resources/"
java="src/main/java/"

function clean_path() {
	if [ -d $backup_path ]; then
		rm -rf ${backup_path}*
	else
		mkdir -p $backup_path
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

function check_del_file() {
	grep "D       " $list_file | tee ibm-partialapp-delete

	if ([ -s ibm-partialapp-delete ]); then
		echo "-------------------------there is deleted files ABOVE------------------------------------"

		sed -i.bak "/D       /d" $list_file

		grep "$webapp" ibm-partialapp-delete | awk -F "$webapp" '{print $2}' >ibm-partialapp-delete.props
		grep "$resources" ibm-partialapp-delete | awk -F "$resources" '{print "WEB-INF/classes/" $2}' >>ibm-partialapp-delete.props
		grep "$java" ibm-partialapp-delete | awk -F "$java" '{print "WEB-INF/classes/" $2}' >>ibm-partialapp-delete.props

                sed -i "s/\.java/\.class/g"  ibm-partialapp-delete.props
		###有bug，若删除的java有内部类,则需从未删除(上一天)的war中获取，不想写了。

		cd $base_path
		for mr in ${META_resources}; do
			sed -i "s#${META_resources_path}${mr}#${mr}#g" ibm-partialapp-delete.props
		done
		cp ibm-partialapp-delete.props ${mother_path}META-INF
	fi
	rm ibm-partialapp-delete
}

function get_and_check_update_list() {
	grep "$webapp" $list_file | awk -F "$webapp" '{print $2}' >$update_list
	grep "$resources" $list_file | awk -F "$resources" '{print "WEB-INF/classes/" $2}' >>$update_list
	grep "$java" $list_file | awk -F "$java" '{print "WEB-INF/classes/" $2}' >$java_list

	cd $mother_path
	awk -F "[.]" '{system("ls " $1 "*.class")}' ${base_path}/$java_list >>${base_path}/$update_list

	cd $base_path
	for mr in $META_resources; do
		sed -i "s#${META_resources_path}${mr}#${mr}#g" $update_list
	done

	if [ -s ibm-partialapp-delete.props ]; then
		wc ibm-partialapp-delete.props
		echo "META-INF/ibm-partialapp-delete.props" >>$update_list
		mv ibm-partialapp-delete.props $backup_path
	fi
	wc ${list_file}* $java_list $update_list

	echo "------------------check the files numbers----------------------"
	grep '\$' $update_list
}

function rsync_file() {
	mkdir -p $rsync_path

	rsync --files-from=$update_list $mother_path $rsync_path${war_file}

	mv ${list_file}* $java_list $update_list $backup_path

}

function zip_zip_file() {
	cd $rsync_path
	[ -f $increment_zip ] && rm -v $increment_zip
	zip -qr $increment_zip ./
	mv $increment_zip $backup_path
}

function zip_war_file() {
	cd $mother_path
	jar -cfM0 $war_file ./
	mv $war_file $backup_path
	cd $base_path
	find Backup/ -maxdepth 1 -mindepth 1 -type d -mtime +7 -exec rm -rf "{}" \;
}

clean_path
unzip_jar
zip_war_file

if [ -s $list_file ]; then
	check_del_file
	get_and_check_update_list
	rsync_file
	zip_zip_file
else
	echo "NEED  $list_file to get update zip file--------------------ERR--ERR--ERR-------------------------------"
fi

##########################################################################################################

earfile=$(ls ${WORKSPACE}/local-webapp/target/*.war | xargs basename)

node=$(echo ${NODE_LABELS})

if [ $node == "master" ]; then

	/home/ap/was/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882 -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${WORKSPACE}'/local-webapp/target/'$earfile' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/GLOBALJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/PAJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'

elif [ $node == "98.9" ]; then

	#拆包全量部署
	#time /home/fb/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${backup_path}${war_file}' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/GLOBALJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/PAJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'
	whoami

	#拆包增量部署

	time /home/fb/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882 -user $username -password $password -c '$AdminApp update '$appname' partialapp {-contents  '${backup_path}${increment_zip}'}'
	whoami

        #不拆包全量部署
        #/home/fb/AppServer/profiles/AppSrv01/bin/wsadmin.sh -host $host -port 8882  -user $username -password $password -c '$AdminApp update '$appname' app  {-operation update -contents '${WORKSPACE}'/local-webapp/target/'$earfile' -contextroot '$contextroot' -usedefaultbindings -MapResRefToEJB{{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpJndiDataSource javax.sql.DataSource jdbc/GLOBALJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpDataSource javax.sql.DataSource jdbc/PAJndiDataSource}{'$earfile' .* '$earfile',WEB-INF/web.xml jdbc/UdmpCommonDataSource javax.sql.DataSource jdbc/UdmpCommonDataSource}}}'
fi
