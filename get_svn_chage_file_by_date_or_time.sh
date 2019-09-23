#!/bin/bash

echo "---------------para 1 system in ( qry nb pa css )--------------------------"
echo "---------------para 2 the day before today to update ----------------------"
echo "---------------need svn_url_qry.txt file to get list ----------------------"
echo "---------------------------------------------------------------------------"

if [ -z "$1" ] ;then 
	echo "use the paragram need para at least 1 like get_svn_update_list.sh qry"
	exit 1
elif [ $1 = "qry" -o $1 = "nb" -o $1 = "pa" -o $1 = "css" ] ; then
	update_system=$1
	svn_url=svn_url_$1.txt
	if [ ! -r $svn_url ] ; then
		echo " $svn_url does not exit ~~~~~~~~~~~~"
	exit 1
	fi
else
	echo "support ( qry nb pa css ) system to update svn list "
	exit 1
fi

# start_date <= svn log file  < end_date
# start_time
# st='2019-9-6T11:00' 

st="$(date +%F -d "$2 days ago")T11:00"

# end_time
# et='2019-8-10T12:00'

et="$(date +%F)T12:00"
et="$(date +%FT%R)"

d=$(date +%F)
list_file="list_${update_system}_$d.txt"

echo  "get update file list from  " $st " to " $et  "  svn change file  " $list_file

cat /dev/null > $list_file

#cat svn_url.txt |sed 's/[[:space:]]//g' | while read line
cat $svn_url |sed 's/[[:space:]]//g' | while read line

do
	url=${line%||*}
	key_words=${line#*||}
	svn diff -r {$st}:{$et} $url --summarize |awk -F $url '/.+[.][^./]+$/ {if($1=="D       ") {print $1 $2} else{print $2}}' |grep -E "$key_words" |tee -a $list_file

done
