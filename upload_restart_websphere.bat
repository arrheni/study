@ECHO off

::CHCP 65001
ECHO use pa clm cap css nb uw qry jrqd 
ECHO e.g: AP2_upload_0.2.bat pa  pa-impl-0.5.0.jar pa-interface-0.5.0.jar pa-web-0.5.0.jar

echo %~dp0  %cd%  !cd!

SET SUBSYSTEM=%1
SET DIR=%cd%
SET JAR1=%2
SET JAR2=%3
SET JAR3=%4
SET JAR4=%5

SET USER=~~~~~
SET PASS=~~~~~~~~~
set ok=

call:setvar
call:echovar
ECHO ----------------------------------------is OK? yes(Y) or no(N)--------------------------------------
set /p ok=is OK? Y or N :

if not "%ok%" == "y" (

echo over by user
goto :eof

) else (
MKDIR %BACKUP_PATH%
call:StopServer
call:backup
call:upload
call:startserver
call:movetodir
call:unsetPara
)

goto:eof


:setvar
IF "%SUBSYSTEM%" == "pa"    (
SET  SERVER_HOST=10.1.95.49
SET  APP=AppSrv02
SET  JAR_FILE=yz1pasap7Node02Cell/local-webapp.ear/local-webapp-0.5.5.3.war
)
IF "%SUBSYSTEM%" == "clm"   (
SET  SERVER_HOST=10.1.95.49
SET  APP=AppSrv02
SET  JAR_FILE=yz1pasap7Node02Cell/local-webapp.ear/local-webapp-0.5.5.3.war
)
IF "%SUBSYSTEM%" == "cap"   (
SET  SERVER_HOST=10.1.95.49
SET  APP=AppSrv02
SET  JAR_FILE=yz1pasap7Node02Cell/local-webapp.ear/local-webapp-0.5.5.3.war
)
IF "%SUBSYSTEM%" == "css"   (
SET  SERVER_HOST=10.1.95.49
SET  APP=AppSrv02
SET  JAR_FILE=COREPTap0Node01Cell/css-web-0_5_5_3_war.ear/css-web-0.5.5.3.war
)
IF "%SUBSYSTEM%" == "nb"    (
SET  SERVER_HOST=10.1.95.50
SET  APP=AppSrv02
SET  JAR_FILE=yz1nbsap4Node02Cell/local-webapp.ear/local-webapp-0.5.4.war
)
IF "%SUBSYSTEM%" == "uw"    (
SET  SERVER_HOST=10.1.95.50
SET  APP=AppSrv02
SET  JAR_FILE=yz1nbsap4Node02Cell/local-webapp.ear/local-webapp-0.5.4.war
)
IF "%SUBSYSTEM%" == "qry"   (
SET  SERVER_HOST=10.1.95.47
SET  APP=AppSrv03
SET  JAR_FILE=qrytap0Node03Cell/qry-web.ear/qry-web.war
)
IF "%SUBSYSTEM%" == "jrqd"  (
SET  SERVER_HOST=10.1.160.5
SET  APP=AppSrv01
SET  JAR_FILE=CloudKVM01Node01Cell/local-webapp-0_5_4_war.ear/local-webapp-0.5.4.war
SET  pass=otXc^^^&A37.
)

IF "%SERVER_HOST%" == ""  pause&goto :eof

IF "%JAR1%" == ""  pause&goto :eof

SET hour=%time:~,2%
IF "%time:~,1%"==" " SET hour=0%time:~1,1%
SET backup_date_dir=%date:~0,4%%date:~5,2%%date:~8,2%
SET backup_time_dir=%hour%%time:~3,2%%time:~6,2%
SET BACKUP_PATH=D:\zengliang\AP2\%backup_date_dir%\buckup_%backup_time_dir%
SET APP_PATH=/home/ap/was/AppServer/profiles/%APP%
SET REMOTE_PATH=%APP_PATH%/installedApps/%JAR_FILE%/WEB-INF/lib
SET REMOTE_FILE1=%REMOTE_PATH%/%JAR1%
SET LOCAL_FILE1=%DIR%\%JAR1%

if  exist "%JAR2%"  (
SET LOCAL_FILE2=%DIR%\%JAR2%
SET REMOTE_FILE2=%REMOTE_PATH%/%JAR2%
)
if  exist "%JAR3%"  (
SET LOCAL_FILE3=%DIR%\%JAR3%
SET REMOTE_FILE3=%REMOTE_PATH%/%JAR3%
)
if  exist "%JAR4%"  (
SET LOCAL_FILE4=%DIR%\%JAR4%
SET REMOTE_FILE4=%REMOTE_PATH%/%JAR4%
)
goto :eof

:echovar
ECHO    ================ECHO VAR===================
ECHO SERVER_HOST=%SERVER_HOST%
ECHO REMOTE_PATH=%REMOTE_PATH%
ECHO REMOTE_FILE1=%REMOTE_FILE1%
ECHO REMOTE_FILE2=%REMOTE_FILE2%
ECHO REMOTE_FILE3=%REMOTE_FILE3%
ECHO REMOTE_FILE4=%REMOTE_FILE4%
ECHO BACKUP_PATH=%BACKUP_PATH%
ECHO LOCAL_FILE1=%LOCAL_FILE1%
ECHO LOCAL_FILE2=%LOCAL_FILE2%
ECHO LOCAL_FILE3=%LOCAL_FILE3%
ECHO LOCAL_FILE4=%LOCAL_FILE4%

goto:eof

:StopServer
ECHO    ===============StopServer==================
pause
plink -ssh -no-antispoof -pw %PASS% %USER%@%SERVER_HOST% "export LANG=en_US.UTF-8;date;time %APP_PATH%/bin/stopServer.sh server1 -username wasadmin -password wasadmin;ls -ltrh %REMOTE_PATH% | tail"
goto:eof

:backup
ECHO    ================Backup=====================
pscp  -pw %PASS%  %USER%@%SERVER_HOST%:%REMOTE_FILE1% %BACKUP_PATH%
if  exist "%JAR2%"  (
pscp  -pw %PASS%  %USER%@%SERVER_HOST%:%REMOTE_FILE2% %BACKUP_PATH%
)
if  exist "%JAR3%"  (
pscp  -pw %PASS%  %USER%@%SERVER_HOST%:%REMOTE_FILE3% %BACKUP_PATH%
)
if  exist "%JAR4%"  (
pscp  -pw %PASS%  %USER%@%SERVER_HOST%:%REMOTE_FILE4% %BACKUP_PATH%
)
goto:eof

:upload
ECHO    ================Upload=====================
pscp -pw %PASS% %LOCAL_FILE1% %LOCAL_FILE2% %LOCAL_FILE3% %LOCAL_FILE4% %USER%@%SERVER_HOST%:%REMOTE_PATH%
goto:eof

:startserver
ECHO    ==============StartServer==================
plink -ssh -no-antispoof -pw %PASS% %USER%@%SERVER_HOST% "export LANG=en_US.UTF-8;date;time  %APP_PATH%/bin/startServer.sh server1;ls -ltrh %REMOTE_PATH% | tail "
goto:eof

:movetodir
ECHO    ================move=====================
move /y   %JAR1%  D:\zengliang\AP2\%backup_date_dir%
if  exist "%JAR2%"  (
move /y   %JAR2%  D:\zengliang\AP2\%backup_date_dir%
)
if  exist "%JAR3%"  (
move /y   %JAR3%  D:\zengliang\AP2\%backup_date_dir%
)
if  exist "%JAR4%"  (
move /y   %JAR4%  D:\zengliang\AP2\%backup_date_dir%
)
goto:eof



:unsetPara
SET SUBSYSTEM=
SET DIR=
SET JAR1=
SET JAR2=
SET JAR3=
SET JAR4=

SET USER=
SET PASS=
SET hour=
SET backup_date_dir=
SET backup_time_dir=
SET BACKUP_PATH=
SET SERVER_HOST=
SET APP=
SET JAR_FILE=
SET REMOTE_PATH=
SET REMOTE_FILE1=
SET LOCAL_FILE1=
SET LOCAL_FILE2=
SET REMOTE_FILE2=
SET LOCAL_FILE3=
SET REMOTE_FILE3=
SET LOCAL_FILE4=
SET REMOTE_FILE4=
SET APP_PATH=
goto:eof

