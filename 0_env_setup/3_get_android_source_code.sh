#!/bin/bash

# Function to display error messages and exit
function error_exit {
    echo "$1" 1>&2
    exit 1
}

# Check if the aosp directory exists and delete it recursively with sudo if it does
AOSP_DIR=~/shiba_debug/aosp
if [ -d "$AOSP_DIR" ]; then
    echo "Directory $AOSP_DIR exists. Deleting it..."
    sudo rm -rf "$AOSP_DIR" || error_exit "Failed to delete $AOSP_DIR"
fi

# Create the aosp directory and navigate into it
echo "Creating directory $AOSP_DIR..."
mkdir -p "$AOSP_DIR" || error_exit "Failed to create directory $AOSP_DIR"
cd "$AOSP_DIR" || error_exit "Failed to navigate to $AOSP_DIR"

echo "Create a password with the password generator to bypass rate-limits"
# Open the link in a browser
xdg-open https://android.googlesource.com/new-password || error_exit "Failed to open web browser"

# User to press enter after copy-pasting the password script
read -p "Copy Google's Password Script as a Command into the Terminal and then Hit Enter:"

echo "Downloading Android Source Code..."
sleep 2

###################################TODO - FIX FROM HERE

# Dev note: android build tag - latest stable - android-14.0.0_r54 - build ID: AP2A.240705.005.A1 (5 Jul 24 release)
REPO_URL="https://android.googlesource.com/platform/manifest"
BRANCH_NAME="android-14.0.0_r54"

repo init --partial-clone -b "$BRANCH_NAME" -u "$REPO_URL" || error_exit "Repo init failed"
repo sync -c -j$(nproc --all) || error_exit "Repo sync failed"

echo "Android Source Download Complete"
echo "Source code located at: $AOSP_DIR"
