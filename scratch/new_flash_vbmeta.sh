#!/bin/bash
# note: fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
# note: this command flashes a modified vbmeta image that disables Android Verified Boot (AVB).

# reboot to fastboot (not fastbootd) - which can be done once in fastboot mode you 
# would just call fastboot reboot fastboot

# clear vbmeta so we can flash our system image and close things back up on the other side

adb reboot bootloader
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
fastboot -w