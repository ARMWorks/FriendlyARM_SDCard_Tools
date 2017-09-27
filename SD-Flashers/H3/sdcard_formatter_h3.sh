#!/bin/sh
#######################################################################
#    sdcard_formatter_h3.sh Format SD Card for H3 based boards
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
# Version 0.1

SDDEV=$1
PART1="1"
PART2="2"
UBOOT=$2

help(){
echo "Usage:";
echo "	sdcard_formatter_h3.sh /dev/sd[x] /path/to/u-boot.bin";
echo "	Formats SD Card, and flashes u-boot.";
exit 0;
}

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
	help
fi

if ! [ -a $UBOOT ]; then
	echo "File does not exist."
	exit 1;
fi

sudo /sbin/fdisk $SDDEV > /dev/null <<EOF
o
n
p
1
49152
131071
n
p
2
131072

w
EOF

sudo dd if=$UBOOT of=$SDDEV bs=1024 seek=8 > /dev/null 2>&1
sudo /sbin/mkfs.fat -n "boot" $SDDEV$PART1 > /dev/null 2>&1
sudo /sbin/mkfs.ext4 -L "rootfs" $SDDEV$PART2 > /dev/null 2>&1
