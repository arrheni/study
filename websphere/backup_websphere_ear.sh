#!/bin/bash

backup_ear="AP2_95.47_`date +%Y%m%d-%H%M%S`_QRY.ear"
target_path="/home/ap/was/AppServer/profiles/AppSrv03/logs"
source_path="/home/ap/was/AppServer/profiles/AppSrv03/installedApps/qrytap0Node03Cell/qry-web.ear"

./EARExpander.sh -ear  ${target_path}/${backup_ear}  -operationDir ${source_path}  -operation collapse

old_ear_file=`find $target_path  -name  "*.ear" -a -mtime +30 | tr '\n' ' ' `
if [ -n "$old_ear_file" ]

then 
    echo "rm $old_ear_file"
    rm -v $old_ear_file
fi
