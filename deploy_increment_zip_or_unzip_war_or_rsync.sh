#!/bin/bash

d=$(date +%F)
#d="2019-08-14"

base_path=`pwd`
mother_path="$base_path/qry-web/target/qry-web/"

war_file="qry-web.war"
list_file="list_qry_$d.txt"
jar_list="jar_qry.txt"
increment_zip="qry-web_increment_$d.zip"

backup_path="${base_path}/Backup/$d/"
rsync_path="${backup_path}Rsync/"
update_list="update_list_$d.txt"
java_list="java_list_$d.txt"
#META_resources=(pa cs clm cap common mobcss images)
META_resources=(common)



#########################################################################################################
from_path="WEB-INF/lib/"
to_class_path="WEB-INF/classes/"
META_resources_path="WEB-INF/classes/META-INF/resources/"

webapp="src/main/webapp/"
resources="src/main/resources/"
java="src/main/java/"


function clean_path()
{
	if [ -d $backup_path ] 
	then
		rm -rf ${backup_path}*
	else
		mkdir -p $backup_path
	fi
}

############################## check svn delete files. need list_qry_$d.txt
function check_del_file()
{
	grep "D       " $list_file | tee ibm-partialapp-delete
	
	if ( [ -s ibm-partialapp-delete ] )
	then
		echo "-------------------------there is deleted files ABOVE------------------------------------"

		sed -i.bak "/D       /d" $list_file

		grep "$webapp" ibm-partialapp-delete | awk -F "$webapp" '{print $2}' > ibm-partialapp-delete.props
		grep "$resources" ibm-partialapp-delete | awk -F "$resources" '{print "WEB-INF/classes/" $2}' >> ibm-partialapp-delete.props
		grep "$java" ibm-partialapp-delete | awk -F "$java" '{print "WEB-INF/classes/" $2}' > $java_list
		rm ibm-partialapp-delete	

		cd $mother_path
		awk -F "[.]" '{system("ls " $1 "*.class")}'  ${base_path}/$java_list  >>${base_path}/ibm-partialapp-delete.props
		
		cd $base_path
		cp ibm-partialapp-delete.props ${mother_path}META-INF 
	fi
}

############################## unzip war & jar.   need svn_jar.txt
function unzip_jar()
{
	#unzip -qo ${war_path}qry-web.war -d ${war_path}qry-web
	cat ${jar_list}|while read line
	do
		unzip_jar=`ls ${mother_path}${from_path}${line}*`
		unzip -qo  ${unzip_jar}  -d ${mother_path}${to_class_path}
		mv ${unzip_jar}  ${backup_path}
	done
	
	for mr in ${META_resources[@]}
	do
	        cp -r ${mother_path}${META_resources_path}${mr}  ${mother_path}
	        rm -r ${mother_path}${META_resources_path}${mr}
	
	done

}

############################## get file copy list

function get_and_check_update_list()
{
	grep "$webapp" $list_file | awk -F "$webapp" '{print $2}' > $update_list
	grep "$resources" $list_file | awk -F "$resources" '{print "WEB-INF/classes/" $2}' >> $update_list
	grep "$java" $list_file | awk -F "$java" '{print "WEB-INF/classes/" $2}' > $java_list
	
	cd $mother_path
	awk -F "[.]" '{system("ls " $1 "*.class")}'  ${base_path}/$java_list  >>${base_path}/$update_list
	
	cd $base_path
	if [ -s ibm-partialapp-delete.props ] ; then 
		echo "META-INF/ibm-partialapp-delete.props" >> $update_list
	fi
	wc ${list_file}* ibm-partialapp-delete.props $java_list $update_list
	
	echo "------------------check the files numbers----------------------"
	grep '\$' $update_list 
}

############################## rsync xml js jsp class to rsync_path
function rsync_file()
{
	mkdir -p $rsync_path
	rsync --files-from=$update_list $mother_path $rsync_path 
	
	mv ${list_file}* ibm-partialapp-delete.props $java_list $update_list $backup_path
}

############################## zip increment file to .zip and jar .war 
function zip_and_jar_file()
{
	cd $rsync_path
	[ -f $increment_zip ] && rm -v $increment_zip
	zip -qr $increment_zip  ./ 
	mv $increment_zip $backup_path
	
	cd $mother_path
	jar -cfM0 $war_file ./
	mv $war_file $backup_path

	cd $base_path
}

############################## deploy zip or war
function deploy()
{
	cd $backup_path

}

if  [  -r $list_file -a -r $jar_list ] ; then
	clean_path
	unzip_jar

	check_del_file
	get_and_check_update_list
	rsync_file
	zip_and_jar_file
else
  	echo "NEED file  $list_file  and  $jar_list  ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--ERR--"
fi
