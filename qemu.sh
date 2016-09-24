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

qemu-system-arm \
    -kernel ${KERNEL}/arch/arm/boot/zImage \
    -dtb ${KERNEL}/arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dtb \
    -serial mon:stdio \
    ${NODISPLAY} \
    -M vexpress-a15 \
    -m 512 \
    -smp 2 \
    -sd root.ext3 \
    -append "${KERNEL_ARG}"

exit 0
