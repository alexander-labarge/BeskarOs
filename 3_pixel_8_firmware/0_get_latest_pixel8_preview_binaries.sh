#!/bin/bash

# Variables
MIRROR_DIR="/usr/local/aosp/mirror"
MAIN_DIR="/usr/local/aosp/main"
REPO_URL="https://android.googlesource.com/platform/manifest"
FIRMWARE_BASE_URL="https://developers.google.com/android/blobs-preview"
EXTRACT_SCRIPT="./extract-google_devices-shiba.sh"

# Function to check command success and exit if failed
check_success() {
    if [ $? -ne 0 ]; then
        echo "Error: $1 failed. Exiting."
        exit 1
    fi
}

# Function to get the latest firmware URL
get_latest_firmware_url() {
    echo "Fetching the latest firmware URL from $FIRMWARE_BASE_URL"
    FIRMWARE_URL=$(curl -s $FIRMWARE_BASE_URL | grep -oP 'https://dl.google.com/dl/android/aosp/google_devices-shiba-\d+-[a-f0-9]+.tgz' | head -n 1)
    check_success "Fetching latest firmware URL"
    echo "Latest firmware URL: $FIRMWARE_URL"
    FIRMWARE_TAR=$(basename $FIRMWARE_URL)
}

# Main script
echo "Getting Proprietary Firmware from Google for the Pixel 8"

# Change directory to build home
echo "Changing directory to $MAIN_DIR"
cd $MAIN_DIR
check_success "Change directory"

# Get the latest firmware URL
get_latest_firmware_url

# Download the firmware
echo "Downloading firmware from $FIRMWARE_URL"
wget $FIRMWARE_URL
check_success "Firmware download"

# Extract the firmware
echo "Extracting firmware from $FIRMWARE_TAR"
bsdtar xvf $FIRMWARE_TAR
check_success "Firmware extraction"

# Run the extraction script
echo "Running extraction script $EXTRACT_SCRIPT"
$EXTRACT_SCRIPT
check_success "Running extraction script"

echo "Firmware Obtained and Extracted - Success."
sleep 2
