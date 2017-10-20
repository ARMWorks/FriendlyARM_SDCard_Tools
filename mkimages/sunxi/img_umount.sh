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

safe_exec(){
    #echo "Running: ${@}"
    eval "$@" || exit 1
}

if [ $(id -u) -ne 0 ]; then
    echo "Please run as sudo user."
    exit 1
fi

help(){
echo "Usage:";
echo "  sudo img_umount.sh /path/to/file.img";
echo "    umount partitions in file.img.";
echo "    Warning, unintentional damage may occur to image data.";
exit 0;
}

if [ $# -eq 0 ] || [ "$1" == "-h" ] || [ "$1" == "--help" ]; then
    help
fi

if ! [ -e $IMG ]; then
    echo "img file does not exist."
    exit 1;
fi

FOUNDLOOPS=false
if [ -d "mounted_$IMG" ]; then
    for i in $(losetup -a | grep $IMG | cut -f1 -d ":")
    do
        MOUNTPOINT=$(mount | grep $i | cut -f3 -d " ")
 
        if [ $MOUNTPOINT != "" ]; then
            safe_exec umount $MOUNTPOINT
        fi
 
        safe_exec losetup -d $i;
        FOUNDLOOPS=true
    done

    if [ $FOUNDLOOPS ]; then
        safe_exec rm -rf mounted_$IMG
    fi
else
    echo "mounted_$IMG does not exist."
    exit 1
fi

exit 0

