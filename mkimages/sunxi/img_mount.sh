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

safe_exec(){
    #echo "Running: ${@}"
    eval $@ || exit 1
}

if [ $(id -u) -ne 0 ]; then
    echo "Please run as sudo user."
    exit 1
fi

help(){
echo "Usage:";
echo "  sudo img_mount.sh /path/to/file.img";
echo "    mount partitions in file.img";
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

for i in $(fdisk -l $IMG | grep "${IMG}[0-9]" | sed -e 's/\*//g' | sed -e 's/  */ /g' | cut -f2 -d " ")
do
    LOOP=$(losetup -f)

    # Requires & or won't unmount correctly for some reason.
    safe_exec losetup -o $(($i*$BS)) $LOOP $IMG &

    # If labels not being found, increase time.
    sleep 2

    MOUNTDIR=$(file -s $LOOP | grep -Po "(label:|volume name) \" *\K([a-zA-Z0-9_\-]*)(?=[ ]*\")")

    if [ $MOUNTDIR == "" ]; then
        MOUNTDIR=$i
    fi

    safe_exec mkdir -p mounted_$IMG/$MOUNTDIR
    safe_exec mount -o loop $LOOP mounted_$IMG/$MOUNTDIR
done
exit 0


