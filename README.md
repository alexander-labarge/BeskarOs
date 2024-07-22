### BeskarOS

## Directory Structure

```sh
skywalker@4090-nvidia-dev:~/beskaros$ tree
.
├── 0_env_setup
│   ├── 0_ubuntu_22_04_base.sh
│   ├── 1_install_newest_adb_fastboot.sh
│   └── 2_install_android_build_tools.sh
└── README.md
```

## Description

This repository contains scripts to set up the build development environment for BeskarOS. The directory structure is as follows:

- **0_env_setup**: Contains the scripts to set up the base environment and install necessary tools.
  - `0_ubuntu_22_04_base.sh`: Script to set up the base environment for Ubuntu 22.04.
  - `1_install_newest_adb_fastboot.sh`: Script to install the latest ADB and Fastboot tools.
  - `2_install_android_build_tools.sh`: Script to install Android build tools.

