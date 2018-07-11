#!/bin/env bash

# This script can be used to quickly mount or unmount devices on Linux
# Tested to work with NTFS, FAT32, exFat filesystems

# If the device name is /dev/sdc1 pass the device name as sdc1

# $1 is for options
# $2 is for partition name

myUser=$(who | awk '{print $1}')

if [ "$1" = '-m' ]
then
	drive=$(lsblk -f | grep $2 | awk '{print $3}')

	if [ -d /media/$myUser/$drive ]
	then
		is_drive=$(lsblk -f | grep $2 | grep /media/$myUser > /dev/null; echo $?)
		is_mount=$(lsblk -f | grep $drive > /dev/null; echo $?)

		if [ $is_drive -eq '0' ]
		then
			echo drive mounted at $(lsblk -f | grep $2 | awk '{print $NF}')
		elif [ $is_mount -eq '0' ]
		then
			mkdir /media/$myUser/$drive-1
			mount -o uid=1000,gid=1000,umask=033 /dev/$2 /media/$myUser/$drive-1
			echo $2 $drive-1 >> /tmp/drive_list.log
#			echo drive mounted at $drive-1
			echo drive mounted at $(lsblk -f | grep $2 | awk '{print $NF}')
		fi
	else
		mkdir /media/$myUser/$drive
		mount -o uid=1000,gid=1000,umask=033 /dev/$2 /media/$myUser/$drive
		echo $2 $drive >> /tmp/drive_list.log
#		echo drive mounted at $drive
		echo drive mounted at $(lsblk -f | grep $2 | awk '{print $NF}')
	fi
elif [ "$1" = '-u' ]
then
	umount /dev/$2
	drive=$(cat /tmp/drive_list.log | grep $2 | awk '{print $2}')
	if [ ! -z "$drive" ]
	then
		rmdir /media/$myUser/$drive
		sed -i "/$2/d" /tmp/drive_list.log
	fi
else
	echo "-m {device name}  to mount"
	echo "-u {device name}  to unmount"
	echo "example: -m sdb1"
fi
