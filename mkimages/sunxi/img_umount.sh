#!/bin/bash
#######################################################################
#    img_umount.sh umount image file with boot/rootfs partitions.
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

if [ "$EUID" -ne 0 ]
  then echo "Please run as sudo user."
  exit 1
fi

help(){
echo "Usage:";
echo "  sudo img_umount.sh /path/to/file.img";
echo "    umount partitions in file.img.";
exit 0;
}

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help
fi

if ! [ -e $IMG ]; then
    echo "img file does not exist."
    exit 1;
fi

for i in $(sudo losetup -a | grep $IMG | cut -f1 -d ":")
do
    sudo umount `mount | grep $i | cut -f3 -d " "`
    sudo losetup -d $i;
done
sudo rm -rf mounted_$IMG
exit 0

