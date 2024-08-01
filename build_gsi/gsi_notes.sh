#!/bin/bash

# GSI Considerations for the Pixel 8
# Note: This process is intricate and must be done precisely to avoid bricking the device.
# Exercise caution and follow the steps exactly.

# The AOSP repo (Android Open Source Project repository) is undergoing many build system changes,
# and the guidance is currently unclear. For the most accurate and up-to-date information,
# refer to the official documentation at:
# https://source.android.com/docs/core/tests/vts/gsi

# GSI (Generic System Image) is no longer maintained on git_aosp_with_phones.
# It is now compiled from the AOSP Main branch. This change was determined through
# bug reports and developer documentation.

# Build targets:
# - For the branch android14-gsi: use gsi_arm64-userdebug
# - For the main (preview) branch: use aosp_arm64-trunk_staging-userdebug

# This script serves as documentation and involves trial and error.
# Modify the build script as you determine the correct steps.

# Define the directory for building the GSI
BUILD_DIR="/mnt/android/beskaros-gsi"

# Create the build directory with the necessary permissions
sudo mkdir -p "$BUILD_DIR"

# Remove any existing repository data from previous builds
sudo rm -rf "$BUILD_DIR"/*

# Change ownership of the build directory to the current user
sudo chown -R "$USER:$USER" "$BUILD_DIR"

# Navigate to the build directory
cd "$BUILD_DIR"

# Initialize the repo with the Android 14 GSI manifest
repo init -u https://android.googlesource.com/platform/manifest

# Synchronize the repo. This downloads the source code.
# The -c option is for the current branch only, and -j8 allows for 8 parallel jobs.
repo sync -c -j8

source build/envsetup.sh

lunch aosp_arm64-trunk_staging-userdebug

# Build the GSI
m -j8

#### build completed successfully (01:24:50 (hh:mm:ss)) ####

# skywalker@deathstar:/mnt/android/beskaros$ echo $ANDROID_PRODUCT_OUT 
# /mnt/android/beskaros/out/target/product/generic_arm64

# flash
# The -w option disables bootloader verification and writes the image to the device.
# The device must be in fastboot mode for this to work.
# Note: Be sure to disable bootloader verification on the device before flashing the GSI.
echo $ANDROID_PRODUCT_OUT 
adb reboot bootloader
fastboot flashing unlock
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
fastboot reboot fastboot
fastboot erase system
fastboot flash system system.img
fastboot -w
fastboot reboot

# skywalker@deathstar:/mnt/android/beskaros$ fastboot flashing unlock
# (bootloader) device already unlocked
# OKAY [  0.039s]
# Finished. Total time: 0.039s
# skywalker@deathstar:/mnt/android/beskaros$ fastboot reboot fastboot
# Rebooting into fastboot                            OKAY [  0.000s]
# < waiting for any device >
# Finished. Total time: 19.338s
# skywalker@deathstar:/mnt/android/beskaros$ fastboot erase system
# Erasing 'system_b'                                 OKAY [  0.059s]
# Finished. Total time: 0.078s
# skywalker@deathstar:/mnt/android/beskaros$ fastboot flash system $ANDROID_PRODUCT_OUT/system.img
# Resizing 'system_b'                                OKAY [  0.015s]
# Sending sparse 'system_b' 1/7 (262116 KB)          OKAY [  6.572s]
# Writing 'system_b'                                 OKAY [  0.666s]
# Sending sparse 'system_b' 2/7 (262116 KB)          OKAY [  6.588s]
# Writing 'system_b'                                 OKAY [  0.651s]
# Sending sparse 'system_b' 3/7 (262116 KB)          OKAY [  6.476s]
# Writing 'system_b'                                 OKAY [  0.718s]
# Sending sparse 'system_b' 4/7 (262124 KB)          OKAY [  6.462s]
# Writing 'system_b'                                 OKAY [  0.649s]
# Sending sparse 'system_b' 5/7 (262128 KB)          OKAY [  6.449s]
# Writing 'system_b'                                 OKAY [  0.664s]
# Sending sparse 'system_b' 6/7 (262124 KB)          OKAY [  6.442s]
# Writing 'system_b'                                 OKAY [  0.658s]
# Sending sparse 'system_b' 7/7 (167064 KB)          OKAY [  4.152s]
# Writing 'system_b'                                 OKAY [  0.683s]
# Finished. Total time: 48.070s
# skywalker@deathstar:/mnt/android/beskaros$ fastboot -w
# Erasing 'userdata'                                 OKAY [  1.712s]
# Erase successful, but not automatically formatting.
# File system type raw not supported.
# wipe task partition not found: cache
# Erasing 'metadata'                                 OKAY [  0.021s]
# Erase successful, but not automatically formatting.
# File system type raw not supported.
# Finished. Total time: 1.781s
# skywalker@deathstar:/mnt/android/beskaros$ 
# The following section is for flashing the latest stable factory image and then the GSI latest.
# This section is for documentation purposes. Uncomment and modify these commands as needed.

# Force flash the latest stable factory image and then the latest GSI.
# Example factory images:
# AP2A.240705.005 (11942872)
# Example GSI: aosp_arm64_pubsign-user (signed)
# AP31.240617.009 (12094726)

# This is just a test to ensure API 31 is working on the current device before
# building it from source (GSI doesn't support bootloader version rollback).
# Note: If you want to experiment with older versions, flash a factory image
# from that platform version, then flash the GSI from that platform version.

# Fastboot commands for flashing the system image:
# Uncomment and use these commands as necessary for your specific use case.
fastboot erase system
fastboot flash system system.img
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img
