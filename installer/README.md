# BeskarOS v0.1.0-alpha

## Overview

Welcome to the BeskarOS v0.1.0-alpha release! This release is designed specifically for the Pixel 8 but is compatible with any Android device manufactured to run Android 8 or later, as this system image is a treble compliant (more info below).

## Included Files

1. **system.img** - (1762.82 MB) The Treble compliant system image.
2. **vbmeta.img** - (0.00 MB) The vbmeta image for flashing.
3. **beskar_flash.sh** - (0.01 MB) Script to flash BeskarOS.
4. **factory_flash.sh** - (0.01 MB) Script to reset the device to the latest public factory build (useful for baselining the device with the latest platform SDK build which the BeskarOS image uses).
5. **fastboot_adb_latest_install.sh** - (0.01 MB) Script to install the latest ADB and Fastboot tools.

## Flashing Instructions

### Flash BeskarOS

To use BeskarOS, execute the `beskar_flash.sh` script. This will flash the custom BeskarOS system image to your device. BeskarOS offers enhanced features and security, leveraging the full potential of your hardware.

**Usage:**
```bash
./beskar_flash.sh
```

### Factory Reset to Latest Public Build

If you encounter issues and want to baseline your device to the latest public factory build, use the `factory_flash.sh` script. This will download, unzip, and flash the factory image to your device, aligning it with the latest platform SDK build.

**Usage:**
```bash
./factory_flash.sh
```

### Install Latest ADB and Fastboot

To install the latest ADB and Fastboot tools, use the `fastboot_adb_latest_install.sh` script. This will ensure you have the latest versions of these essential tools.

**Usage:**
```bash
./fastboot_adb_latest_install.sh
```

## What is Project Treble?

Project Treble is an initiative by Google to make it easier and faster for manufacturers to update devices to new Android versions. By modularizing the Android OS framework, Treble allows the core Android OS to be updated independently of the device-specific low-level software. This results in several benefits:

- **Compatibility:** Devices running Android 8 (Oreo) or later are Treble compliant, meaning the provided system image can work across various devices without modification.
- **Faster Updates:** Manufacturers can deliver updates more quickly without needing to rework the entire OS for each device.
- **Longer Device Lifespan:** Users can enjoy the latest Android features and security updates on older devices.

The Treble compliant system image included in this release ensures compatibility with any Android device that supports Project Treble, providing a seamless flashing experience.

## Notes

- Ensure you have `adb` and `fastboot` installed and available in your `PATH`.
- The Treble compliant system image ensures compatibility with any Android device running Android 8 or later.

---

Feel free to copy and paste this into your release's README section!