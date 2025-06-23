#!/bin/bash

CUR_PATH=${PWD}

#check arg number
if [ $# != 1 ];then
    echo "Usage: ./mk-sdcard.sh /dev/sdb"
    exit
fi

# check the if root?
userid=`id -u`
if [ $userid -ne "0" ]; then
echo "you're not root?"
exit
fi

#check image file exist or not?
files=${CUR_PATH}/sdcard.tgz
if [ -z "$files" ]; then
echo "There are no file in image folder."
exit
fi

#avoid format my computer
if [ "$1" == "/dev/sda" ];then
        echo "cannot format your filesystem"
        exit
fi

node=$1
#check if /dev/sdx exist?
if [ ! -e ${node} ]; then
echo "There is no "${node}" in you system"
exit
fi

echo "All data on "${node}" now will be destroyed! Continue? [y/n]"
read ans
if [[ "$ans" != [Yy] ]]; then exit 1; fi

# umount device
umount ${node}* &> /dev/null

# destroy the partition table
dd if=/dev/zero of=${node} bs=1k count=1024 conv=fsync &> /dev/null;sync

#partition
echo "partition start"
A=10	#in MiB

parted -a optimal --script "${node}" \
	mklabel msdos \
	mkpart primary fat32 "$A"MiB 100% \
	set 1 boot on \
	print

if [ -x /sbin/partprobe ]; then
	/sbin/partprobe ${node} &> /dev/null
else
	sleep 1
fi

sync
sync

echo "partition done"
# format filesystem
mkfs.vfat -F 32 -n "BOOT" ${node}1
sync;sync

umount mount_point0 &> /dev/null
rm -fr mount_point0 &> /dev/null
mkdir mount_point0

if ! mount ${node}1 mount_point0 &> /dev/null; then 
	echo  "Cannot mount ${node}1"
	exit 1
fi
rm -fr mount_point0/*

tar xvzf ${files} -C .
cp -av sdcard/* mount_point0/
sync
sync

umount ${node}1
sync
sync
rm -rf sdcard
rmdir mount_point0
sync

printf "\033[1;32m"
echo "[Done]"
printf "\033[0;00m"
