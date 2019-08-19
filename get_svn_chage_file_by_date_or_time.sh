# start_date <= svn log file  < end_date
# start_time
st="$(date +%F -d "$1 days ago")T11:00"
#st='2019-8-6T11:00' 

# end_time
et="$(date +%F)T12:00"
#et='2019-8-10T12:00'

d=$(date +%F)
echo  "from  " $st " to " $et  "  svn change  file  " list_qry_$d.txt

###### get svn change files list. need svn_url.txt
#cat  /dev/null >list_qry_$d.txt
>list_qry_$d.txt

cat svn_url.txt |sed 's/[[:space:]]//g' | while read line
do
	url=${line%||*}
	key_words=${line#*||}
	svn diff -r {$st}:{$et} $url --summarize |awk -F $url '/.+[.][^./]+$/ {if($1=="D       ") {print $1 $2} else{print $2}}' |grep -E "$key_words" >>list_qry_$d.txt
done
