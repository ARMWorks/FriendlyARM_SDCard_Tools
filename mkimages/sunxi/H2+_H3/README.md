# Create SD Card Image File #
Creates the .img file to flash to the SD Card.

## Usage ##

    sudo ./img_builder.sh your.img /path/to/u-boot.bin
    sudo ./img_mount.sh your.img

This will mount boot/ and rootfs/ partitions in mounted\_your.img/ directory. You can now copy all the necessary files into thier respective directories.

    sudo ./img_umount.sh your.img
    sudo dd if=your.img of=/dev/sd?

This unmounts the image then flashes it to your SD Card, make sure you get the right device name of your SD Card using dmesg after pluging it in.

## Issues ##

* img\_builder.sh will complain about lower case DOS label, shouldn't be an issue.

* If something goes wrong, check with 'sudo losetup -a' to see if the loop devices are still in use, if so 'sudo losetup -d /dev/loopX' and/or umount directories, should clean things up.
