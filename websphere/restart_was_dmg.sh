
#!/bin/sh
dmgrDir=/home/ap/was/AppServer/profiles/Dmgr01/bin
profileDir=/home/ap/was/AppServer/profiles/AppSrv01/bin


kill -9 `ps -ef|grep dmgr|grep Dmgr01|awk '{print $2}'`
kill -9 `ps -ef|grep node|grep AppSrv01|awk '{print $2}'`
kill -9 `ps -ef|grep server1|grep AppSrv01|awk '{print $2}'`
kill -9 `ps -ef|grep server2|grep AppSrv01|awk '{print $2}'`

cd ${dmgrDir}
sh startManager.sh 


cd ${profileDir}
sh startNode.sh
sh startServer.sh server1
sh startServer.sh server2
