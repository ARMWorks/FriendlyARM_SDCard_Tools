# Create SD Card Image File #
Creates the .img file to flash to the SD Card.

## Usage ##

* Create your.img and put u-boot in it. For H2+ and H3.

    sudo ./img_builder.sh your.img /path/to/u-boot.bin

For H5:
    
    sudo img_builder.sh /path/to/file.img /path/to/sunxi-spl.bin /path/to/u-boot.itb

* Mount boot/ and rootfs/ partitions in the newly created mounted\_your.img/ directory. You can now copy all the necessary files into thier respective directories.

    sudo ./img_mount.sh your.img

* Unmount boot/ and rootfs/ directories and remove mounted\_your.img/.

    sudo ./img_umount.sh your.img

* Flash your.img to the SD Card.

    sudo dd if=your.img of=/dev/sd?


## Issues ##

* img\_builder.sh will complain about lower case DOS label, shouldn't be an issue.

* If something goes wrong, check with 'sudo losetup -a' to see if the loop devices are still in use, if so 'sudo losetup -d /dev/loopX' and/or umount directories, should clean things up.
