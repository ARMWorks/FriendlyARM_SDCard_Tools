# FriendlyARM_SDCard_Tools
FriendlyARM tools for making SD Cards and creating installable file system images.

## Troubleshooting

* **command not found** When running mkimage* binaries:

  *  These are 32 bit binaries, and will need the appropriate libs on a 64 bit system.
  ```
    dpkg --add-architecture i386
    apt-get update
    apt-get install libc6-i386
  ```
