#!/bin/bash

DIR=$(dirname "$0")
KERNEL="linux-4.7.4"
UBOOT="u-boot-2016.09"

KERNEL_ARG=" \
    root=/dev/mmcblk0 rw \
    init=/init \
    mem=512M \
    rootwait"

#KERNEL_ARG+=" earlyprintk "
#KERNEL_ARG+=" console=tty0 "
KERNEL_ARG+=" console=ttyAMA0,115200n8 "

cd $DIR

NODISPLAY=" -display none "

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
