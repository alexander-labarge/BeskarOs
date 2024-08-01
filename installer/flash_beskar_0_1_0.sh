#!/bin/bash

# Check if adb is installed
if ! command -v adb &> /dev/null; then
    echo "adb is not installed. Please install adb and try again."
    exit 1
fi

# Check if fastboot is installed
if ! command -v fastboot &> /dev/null; then
    echo "fastboot is not installed. Please install fastboot and try again."
    exit 1
fi

# Check if adb version is at least 35
adb_version=$(adb --version | grep -oP 'Version \K[0-9]+\.[0-9]+' | head -1)
adb_major_version=$(echo $adb_version | cut -d. -f1)

if [ "$adb_major_version" -lt 35 ]; then
    echo "adb version is less than 35. Please update adb and try again."
    exit 1
fi

# Check if fastboot version is at least 35
fastboot_version=$(fastboot --version | grep -oP 'fastboot version \K[0-9]+\.[0-9]+' | head -1)
fastboot_major_version=$(echo $fastboot_version | cut -d. -f1)

if [ "$fastboot_major_version" -lt 35 ]; then
    echo "fastboot version is less than 35. Please update fastboot and try again."
    exit 1
fi

# Check if adb devices returns a device
device_count=$(adb devices | grep -w "device" | wc -l)
if [ "$device_count" -eq 0 ]; then
    echo "No device found. Please connect a device and try again."
    exit 1
fi

# Reboot the device into bootloader mode
adb reboot bootloader

# Unlock the bootloader
fastboot flashing unlock

# Disable verity and verification, then flash vbmeta
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img

# Reboot into fastboot mode
fastboot reboot fastboot

# Erase the current system
fastboot erase system

# Flash the new system image
fastboot flash system system.img

# Perform a factory reset
fastboot -w

# Reboot the device
fastboot reboot

# Check if the last command was successful
if [ $? -eq 0 ]; then
    echo "Device successfully flashed and rebooted."
else
    echo "An error occurred during the flashing process."
    exit 1
fi
