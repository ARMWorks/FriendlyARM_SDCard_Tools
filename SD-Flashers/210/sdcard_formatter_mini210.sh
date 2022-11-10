#!/bin/sh
#######################################################################
#    sdcard_formatter_mini210.sh Format SD Card for Mini210 SuperBoot
#    Copyright (C) 2014 Jason Pruitt
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
SDPART="1"
SB=$2
help(){
echo "Usage:";
echo "	sdcard_formatter_mini210.sh /dev/sd[x] /path/to/SuperBoot210.bin";
echo "	Formats SD Card, makes FAT32 partition, and copies Superboot to beginning of card.";
exit 0;
}

if [ $# -eq 0 ] || [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
	help
fi

if ! [ -a $SB ]; then
	echo "File does not exist."
	exit 1;
fi

(echo o; echo n; echo p; echo 1; echo ; echo ; echo t; echo c;  echo w;) | sudo /sbin/fdisk $SDDEV > /dev/null 2>&1

sudo /sbin/mkfs.msdos -n "FriendlyARM" $SDDEV$SDPART > /dev/null 2>&1

dd if=$SB of=$SDDEV bs=512 seek=1 > /dev/null 2>&1
