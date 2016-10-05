#!/bin/bash

DIR=$(dirname "$0")
#KERNEL="linux-4.7.4"
# Use custom output directory as kernel objs
KERNEL="out"
UBOOT="u-boot-2016.09"

KERNEL_ARG=" \
    root=/dev/mmcblk0 rw \
    mem=512M \
    rootwait "

#KERNEL_ARG+=" earlyprintk "
KERNEL_ARG+=" loglevel=8 "
#KERNEL_ARG+=" console=tty0 "
KERNEL_ARG+=" console=ttyAMA0,115200n8 "

cd $DIR

NODISPLAY=" -display none "

#NETDEV=" -net nic,model=lan9118,netdev=n0 -netdev user,id=n0 "
#NETDEV=" -net nic,model=virtio,vlan=0,macaddr=00:16:3e:00:01:01 -net tap,vlan=0,script=/root/ifup-br0,downscript=/root/ifdown-br0 "
NETDEV=" -net nic,macaddr=00:e0:4c:11:b1:5a -net tap,ifname=tap0,script=ifup-tap0,downscript=ifdown-tap0 "
KERNEL_ARG+=" ip=192.168.1.12::192.168.1.1:255.255.0.0 "

qemu-system-arm \
    -kernel ${KERNEL}/arch/arm/boot/zImage \
    -dtb ${KERNEL}/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dtb \
    -serial mon:stdio \
    ${NODISPLAY} \
    ${NETDEV} \
    -M vexpress-a15 \
    -m 512 \
    -smp 2 \
    -sd root.ext3 \
    -append "${KERNEL_ARG}"

exit 0
