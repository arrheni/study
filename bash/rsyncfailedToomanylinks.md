# rsync failed: Too many links

rsync: recv_generator: mkdir "/home/backupalm/tomcat/upload_file/upload_file/file/3/test_case/1655520557122" failed: Too many links (31)
*** Skipping any contents from this failed directory ***
upload_file/file/3/test_case/1655520880802/
rsync: recv_generator: mkdir "/home/backupalm/tomcat/upload_file/upload_file/file/3/test_case/1655520880802" failed: Too many links (31)
*** Skipping any contents from this failed directory ***rsync: recv_generator: mkdir "/app/data/ckl/ckli2780581" failed: Too many links (31)
*** Skipping any contents from this failed directory **

[root@core9516 ~]# df -Th
Filesystem    Type    Size  Used Avail Use% Mounted on
/dev/mapper/VolGroup00-LogVol00
              ext3    1.5T  111G  1.3T   8% /
/dev/sda3     ext3     92M   13M   74M  15% /boot
tmpfs        tmpfs     16G     0   16G   0% /dev/shm

[root@core9516 ~]# cd /home/backupalm/tomcat/upload_file/upload_file/file/3/test_case/
[root@core9516 test_case]# ls | wc -l
31998

大概如下：

nclude/linux/ext2_fs.h:#define EXT2_LINK_MAX           32000
include/linux/ext3_fs.h:#define EXT3_LINK_MAX           32000



为什么说31998个呢？这是因为mkdir创建一个目录时，目录下默认就会创建两个子目录的，一个是.目录（代表当前目录），另一个是..目录（代表上级目录）。这两个子目录是删除不掉的，“ rm . ” 会得到“rm: cannot remove `.' or `..'”的提示。所以32000-2=31998。

解决：

ext4 对目录个数没有限制

挂载一块新盘，将目录建立连接

脚本如下：


#!/bin/bash
CUR_DAY=`date +%Y%m%d`
SRC_DIR=/app
DST_DIR=/data

fdisk /dev/vdc <<EOF

EOF

echo
echo "star create vg and lv..."
pvcreate /dev/sdc1
if [ $? -eq 0 ];then
	vgcreate data-volume /dev/vdc1
	if [ $? -eq 0 ];then
		lvcreate -L 99G -n s1_data data-volume
	else
		echo "lv create failed!"
		exit 1
else
	echo "vg create failed !"
fi
mkfs -t ext4 /dev/data-volume/s1_data
