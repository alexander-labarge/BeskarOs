### BeskarOS

## Directory Structure

```sh
skywalker@4090-nvidia-dev:~/beskaros$ tree
.
├── 0_env_setup
│   ├── 0_ubuntu_22_04_base.sh
│   ├── 1_install_newest_adb_fastboot.sh
│   ├── 2_install_android_build_tools.sh
│   └── 3_get_android_source_code.sh
├── 1_pixel_8_firmware
│   └── 0_get_proprietary_firmware_pixel8.sh
└── README.md

2 directories, 6 files
```

## Description

This repository contains scripts to set up the build development environment for BeskarOS. The directory structure is as follows:

- **0_env_setup**: Contains the scripts to set up the base environment and install necessary tools.
  - `0_ubuntu_22_04_base.sh`: Script to set up the base environment for Ubuntu 22.04.
  - `1_install_newest_adb_fastboot.sh`: Script to install the latest ADB and Fastboot tools.
  - `2_install_android_build_tools.sh`: Script to install Android build tools.
  - `3_get_android_source_code.sh`: Script to initialize and sync the Android source code repository.

- **1_pixel_8_firmware**: Contains the script to manage the proprietary firmware for Pixel 8.
  - `0_get_proprietary_firmware_pixel8.sh`: Script to download and set up the proprietary firmware for Pixel 8.

## Setup Instructions

To set up the environment, run the scripts in the following order:

1. **Set up the base environment**:
   ```sh
   ./0_env_setup/0_ubuntu_22_04_base.sh
   ```

2. **Install the newest ADB and Fastboot tools**:
   ```sh
   ./0_env_setup/1_install_newest_adb_fastboot.sh
   ```

3. **Install Android build tools**:
   ```sh
   ./0_env_setup/2_install_android_build_tools.sh
   ```

4. **Get Android source code**:
   ```sh
   ./0_env_setup/3_get_android_source_code.sh
   ```

5. **Get proprietary firmware for Pixel 8**:
   ```sh
   ./1_pixel_8_firmware/0_get_proprietary_firmware_pixel8.sh
   ```

## Script Usage
### Pending..