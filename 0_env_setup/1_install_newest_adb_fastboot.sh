#!/bin/bash

set -e

echo "Beginning Setup for Android Development Environment"

sudo apt install curl -y
sudo apt install libarchive-tools -y
# only installing apt adb for udev rules setup
# then we will compile our own and replace it, but the udev rules are done for us
sudo apt-get install android-sdk-platform-tools -y 
sudo rm /usr/bin/fastboot && sudo rm /usr/bin/adb
curl -O https://dl.google.com/android/repository/platform-tools-latest-linux.zip
bsdtar xvf platform-tools*.zip
sudo cp -r ./platform-tools /opt
sudo rm -r ./platform-tools*
sudo chown -R $USER:$USER /opt/platform-tools
export PATH="/opt/platform-tools:$PATH" && echo "export PATH=$PATH" >> ~/.bashrc
echo "#########################################################################"
echo "Latest ADB and Fastboot installed and added to Path"
fastboot --version
adb --version
echo "#########################################################################"