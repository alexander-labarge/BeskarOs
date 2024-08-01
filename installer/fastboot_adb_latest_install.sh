#!/bin/bash

set -e

echo "Beginning Setup for Android Development Environment"

# Install required packages
sudo apt update
sudo apt install -y curl libarchive-tools android-sdk-platform-tools

# Remove existing adb and fastboot binaries
sudo rm -f /usr/bin/fastboot /usr/bin/adb

# Download and extract the latest platform tools
curl -O https://dl.google.com/android/repository/platform-tools-latest-linux.zip
bsdtar -xvf platform-tools-latest-linux.zip

# Move the extracted platform tools to /opt
sudo mv platform-tools /opt/platform-tools
sudo chown -R $USER:$USER /opt/platform-tools

# Add platform-tools to the PATH
if ! grep -q 'export PATH=/opt/platform-tools:$PATH' ~/.bashrc; then
    echo 'export PATH=/opt/platform-tools:$PATH' >> ~/.bashrc
fi
export PATH="/opt/platform-tools:$PATH"

# Clean up
rm platform-tools-latest-linux.zip

echo "#########################################################################"
echo "Latest ADB and Fastboot installed and added to Path"
echo "#########################################################################"
fastboot --version
adb --version
echo "sourcing bashrc"
source ~/.bashrc
echo "bashrc source done"