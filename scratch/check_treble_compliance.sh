skywalker@deathstar:~/AndroidStudioProjects/SilverBall$ adb shell getprop ro.treble.enabled
true
skywalker@deathstar:~/AndroidStudioProjects/SilverBall$ adb shell getprop ro.build.version.release
14
skywalker@deathstar:~/AndroidStudioProjects/SilverBall$ adb shell getprop ro.product.cpu.abi
arm64-v8a



Good to know:
Root of Trust
Root of trust is the cryptographic key used to sign the copy of Android stored on the device. The private part of the root of trust is known only to the device manufacturer and is used to sign every version of Android intended for distribution. The public part of the root of trust is embedded in the device and is stored in a place so it cannot be tampered with (typically read-only storage).

When it loads Android, the bootloader uses the root of trust to verify authenticity. For more details on this process, see Verifying Boot. Devices may have multiple boot loaders and as such multiple cryptographic keys may be in play.

User-settable root of trust
Devices can optionally allow the user to configure the root of trust (for example, a public key). Devices can use this user-settable root of trust for Verified Boot instead of the built-in root of trust. This allows the user to install and use custom versions of Android without sacrificing the security improvements of Verified Boot.

If user-settable root of trust is implemented, it should be done in a way such that:

Physical confirmation is required to set/clear the user-settable root of trust.
The user-settable root of trust can only be set by the end user. It cannot be set at the factory or any intermediate point before the end user gets the device.
The user-settable root of trust is stored in tamper-evident storage. Tamper-evident means that it's possible to detect if Android has tampered with the data, for example, if it has been overwritten or changed.
If a user-settable root of trust is set, the device should allow a version of Android signed with either the built-in root of trust or the user-settable root of trust to boot.
Every time the device boots using the user-settable root of trust, the user should be notified that the device is loading a custom version of Android. For example, warning screens, see LOCKED devices with custom key set.
One way of implementing user-settable root of trust is to have a virtual partition that can only be flashed or cleared when the device is in the UNLOCKED state. The Google Pixel 2 devices use this approach and the virtual partition is called avb_custom_key. The format of the data in this partition is the output of the avbtool extract_public_key command. Here's an example of how to set the user-settable root of trust:


avbtool extract_public_key --key key.pem --output pkmd.bin
fastboot flash avb_custom_key pkmd.bin
The user-settable root of trust can be cleared by issuing:


fastboot erase avb_custom_key