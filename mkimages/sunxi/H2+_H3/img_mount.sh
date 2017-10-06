#!/bin/bash
#######################################################################
#    img_mount.sh mount image file with boot/rootfs partitions.
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

IMG=$1
BS=512

if [ "$EUID" -ne 0 ]
  then echo "Please run as sudo user."
  exit 1
fi

help(){
echo "Usage:";
echo "  sudo img_mount.sh /path/to/file.img";
echo "    mount partitions in file.img";
exit 0;
}

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help
fi

if ! [ -a $IMG ]; then
    echo "img file does not exist."
    exit 1;
fi

PART1START=$(sudo fdisk -l $IMG | grep "${IMG}1" | sed -e 's/  */ /g' | cut -f2 -d " ")
PART2START=$(sudo fdisk -l $IMG | grep "${IMG}2" | sed -e 's/  */ /g' | cut -f2 -d " ")

LOOP0=$(losetup -f)
losetup -o $(($PART1START*$BS)) $LOOP0 $IMG &
mkdir -p mounted_$IMG/boot
mount -o loop $LOOP0 mounted_$IMG/boot

LOOP1=$(losetup -f)
losetup -o $((($PART2START)*$BS)) $LOOP1 $IMG &
mkdir -p mounted_$IMG/rootfs
mount -o loop $LOOP1 mounted_$IMG/rootfs

exit 0

