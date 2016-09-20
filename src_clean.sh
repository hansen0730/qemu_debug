#!/bin/bash

DIR=$(dirname "$0")
KERNEL="linux-4.7.4"
cd $DIR/${KERNEL}

cd arch
mkdir bak
mv * bak/ -f
mv bak/{arm,Kconfig} .
rm bak -rf
cd -

