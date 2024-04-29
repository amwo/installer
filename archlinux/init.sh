#!/bin/bash -e

if [ $# -eq 1 ];then
    sgdisk -z $1
    sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" $1
    sgdisk -n 2:0: -t 2:8300 -c 2:"Linux filesystem" $1
fi

if [ $# -eq 2 ];then
    sgdisk -z $1
    sgdisk -z $2

    sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" $1
    sgdisk -n 2:0: -t 2:8300 -c 2:"Linux filesystem" $1 &&

    sgdisk -n 1:0: -t 1:8300 -c 1:"Linux filesystem" $2
    echo "two"
fi

exit 0
