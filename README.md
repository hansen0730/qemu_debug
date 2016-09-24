# Use QEMU for kernel debug

[TOC]

## Versions Info
uboot: 2016.09  
linux kernel: 4.7.4  
busybox: 1.25.0  
buildroot: 2016.08  
qemu-system-arm: 2.5.0  

Ubuntu: 16.04  

## Install softwares
apt-get install gcc-arm-linux-gnueabi g++-arm-linux-gnueabi qemu-system-arm  

## Create Root Image as ext3
dd if=/dev/zero of=root.ext3 bs=300M count=1  
mkfs.ext3 -L root root.ext3  

## Mount Root Image
mkdir root  
~~sudo mount -t ext3 -o sync,nolazytime,atime,commit=1 root.ext3 root~~
sudo mount -t ext3 -o commit=1 root.ext3 root  

## Build kernel
cp ==kernel_defconfig== &lt;kernel_source&gt;/.config  
make O=../out ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- olddefconfig  
make O=../out ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- menuconfig  
make O=../out ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- zImage  
make O=../out ARCH=arm CROSS_COMPILE=arm-linux-gnueabi- dtbs  

## Boot without uboot
./qemu.sh  

## Qemu operate usage
CTRL-a + c; enter/exit QEMU console  
== In QEMU console ==
system_reset; reboot system  
quit; terminate QEMU  

## Use buildroot generate root file system
cp ==buildroot_defconfig== buildroot-2016.08/.config  
make olddefconfig  
make menuconfig  
make  
cp output/target/* &lt;root_disk&gt;/ -ar  
==chown root:root &lt;root_disk&gt;/ -R==
