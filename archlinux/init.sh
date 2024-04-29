#!/bin/bash -e

if [ $# -eq 1 ];then
    sgdisk -z $1
    sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" $1
    sgdisk -n 2:0: -t 2:8300 -c 2:"Linux filesystem" $1

    mkfs.vfat -F32 "${1}p1"
    mkfs.ext4 -F32 "${1}p2"

    mkdir -p /mnt/boot
fi

if [ $# -eq 2 ];then
    sgdisk -z $1
    sgdisk -z $2

    sgdisk -n 1:0:+512M -t 1:ef00 -c 1:"EFI System" $1
    sgdisk -n 2:0: -t 2:8300 -c 2:"Linux filesystem" $1 &&

    sgdisk -n 1:0: -t 1:8300 -c 1:"Linux filesystem" $2

    mkfs.vfat -F32 "${1}p1" &&
    mkfs.ext4 "${1}p2" &&

    mkfs.ext4 "${2}p1" &&

    mkdir -p /mnt/boot/efi /mnt/data &&

    mount "${1}p1" /mnt/boot/efi &&
    mount "${1}p2" /mnt &&
    mount "${2}p1" /mnt/data
fi

echo "" > /etc/pacman.d/mirrorlist &&
echo 'Server = https://ftp.tsukuba.wide.ad.jp/Linux/archlinux/$repo/os/$arch' > /etc/pacman.d/mirrorlist &&
pacstrap /mnt base base-devel linux linux-firmware archlinux-keyring vi vim dhcpcd amd-ucode nvidia nvidia-utils git zsh ripgrep fzf htop man &&
genfstab -U /mnt >> /mnt/etc/fstab

exit 0
