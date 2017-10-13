#!/bin/bash
#######################################################################
#    img_builder.sh Create image file with boot/rootfs partitions and uboot.
#    Copyright (C) 2017 Jason Pruitt
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
##########################################################################

IMGSIZE=500000
IMG=$1
UBOOT=$2
PART1START=49152
PART1END=131071
BS=512

if [ "$EUID" -ne 0 ]
  then echo "Please run as sudo user."
  exit 1
fi

help(){
echo "Usage:";
echo "  sudo img_builder.sh /path/to/file.img /path/to/u-boot.bin";
echo "    Format img file with paritions and u-boot.";
exit 0;
}

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help
fi
echo $UBOOT
if ! [ -e "$UBOOT" ]; then
    echo "u-boot file does not exist."
    exit 1;
fi

if ! [ -e "$IMG" ]; then
    dd if=/dev/zero of=$IMG bs=1024 count=$IMGSIZE > /dev/null 2>&1
fi

sudo /sbin/fdisk $IMG > /dev/null <<EOF
o
n
p
1
$PART1START
$PART1END
n
p
2
$(($PART1END+1))


w
EOF

dd if=$UBOOT of=$IMG bs=1024 seek=8 conv=notrunc > /dev/null 2>&1

LOOP0=$(losetup -f)
losetup -o $(($PART1START*$BS)) $LOOP0 $IMG > /dev/null &
sleep 1
mkfs.vfat -n "boot" $LOOP0 > /dev/null 
losetup -d $LOOP0 > /dev/null 

LOOP1=$(losetup -f)
losetup -o $((($PART1END+1)*$BS)) $LOOP1 $IMG > /dev/null  &
sleep 1
/sbin/mkfs.ext4 -L "rootfs" $LOOP1 > /dev/null 
losetup -d $LOOP1 > /dev/null 

exit 0;



