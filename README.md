# Use QEMU for kernel debug

[TOC]

## Versions Info
uboot: 2016.09  
linux kernel: 4.7.4  
busybox: 1.25.0  
buildroot: 2016.08  
qemu-system-arm: 2.8.1  

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
cp kernel_defconfig kernel_source/.config  
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

Needs self add /dev/null and /dev/urandom char type devices in root filesystem.
Default username: root, password: admin  

## Enable Network
sudo apt-get install bridge-utils uml-utilities libvirt-bin  
QEMU with arg  
 -net nic,macaddr=00:e0:4c:11:xx:xx -net tap,ifname=tap0,script=ifup-tap0,downscript=ifdown-tap0  

#/etc/network/interfaces Append  
#auto virbr0  
#iface virbr0 inet dhcp  
#	bridge_ports eth0  
#	bridge_stp off  
#	bridge_fd 0  
#	bridge_maxwait 0  
  
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE  
sudo iptables -A INPUT -i tap0 -j ACCEPT  
sudo iptables -A INPUT -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT  
sudo iptables -A OUTPUT -j ACCEPT  
sudo sysctl -w net.ipv4.ip_forward=1  
  
On Board  
route add default gw 192.168.1.1  
ifconfig eth0 192.168.10.2  

