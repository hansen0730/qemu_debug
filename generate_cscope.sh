#!/bin/bash

DIR=$(dirname "$0")
KERNEL="linux-4.7.4"
cd $DIR/${KERNEL}

find . \
	-path ./scripts -prune -o \
	-path ./samples  -prune -o \
	-path ./tools -prune -o \
	-path ./Documentation -prune -o \
	-path ./drivers -prune -o \
	-name "*.[c|h]" > cscope.files

cscope -bRq -F cscope.files -s drivers/of -s drivers/clk -s drivers/clk

