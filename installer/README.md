# Flashing BeskarOS

This guide provides instructions to flash BeskarOS onto your Pixel 8 device using `adb` and `fastboot`.
Note: this guide is being populated as the build process changes - flash_beskar_xxxx.sh will always be embedded
    within a release package.

## Prerequisites

1. Ensure `adb` is installed:
    ```bash
    if ! command -v adb &> /dev/null; then
        echo "adb is not installed. Please install adb and try again."
        exit 1
    fi
    ```

2. Ensure `fastboot` is installed:
    ```bash
    if ! command -v fastboot &> /dev/null; then
        echo "fastboot is not installed. Please install fastboot and try again."
        exit 1
    fi
    ```

3. Check if `adb` version is at least 35:
    ```bash
    adb_version=$(adb --version | grep -oP 'Version \K[0-9]+\.[0-9]+' | head -1)
    adb_major_version=$(echo $adb_version | cut -d. -f1)

    if [ "$adb_major_version" -lt 35 ]; then
        echo "adb version is less than 35. Please update adb and try again."
        exit 1
    fi
    ```

4. Check if `fastboot` version is at least 35:
    ```bash
    fastboot_version=$(fastboot --version | grep -oP 'fastboot version \K[0-9]+\.[0-9]+' | head -1)
    fastboot_major_version=$(echo $fastboot_version | cut -d. -f1)

    if [ "$fastboot_major_version" -lt 35 ]; then
        echo "fastboot version is less than 35. Please update fastboot and try again."
        exit 1
    fi
    ```

5. Ensure a device is connected:
    ```bash
    device_count=$(adb devices | grep -w "device" | wc -l)
    if [ "$device_count" -eq 0 ]; then
        echo "No device found. Please connect a device and try again."
        exit 1
    fi
    ```

## Flashing Steps

1. Reboot the device into bootloader mode:
    ```bash
    adb reboot bootloader
    ```

2. Unlock the bootloader:
    ```bash
    fastboot flashing unlock
    ```

3. Disable verity and verification, then flash `vbmeta`:
    ```bash
    fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
    ```

4. Reboot into fastboot mode:
    ```bash
    fastboot reboot fastboot
    ```

5. Erase the current system:
    ```bash
    fastboot erase system
    ```

6. Flash the new system image:
    ```bash
    fastboot flash system system.img
    ```

7. Perform a factory reset:
    ```bash
    fastboot -w
    ```

8. Reboot the device:
    ```bash
    fastboot reboot
    ```

9. Verify the flashing process:
    ```bash
    if [ $? -eq 0 ]; then
        echo "Device successfully flashed and rebooted."
    else
        echo "An error occurred during the flashing process."
        exit 1
    fi
    ```