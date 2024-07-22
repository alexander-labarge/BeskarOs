#!/bin/bash

# Define variables
C_FILE="beskar_usb_manager.c"
MODULE_NAME="beskar_usb_manager"
BUILD_DIR="$HOME/shiba_debug/aosp/device/google/beskar_usb_manager"
INCLUDE_DIR="system/core/libusbhost/include"

# Check if the C file exists in the current directory
if [ ! -f "$C_FILE" ]; then
  echo "Error: File '$C_FILE' not found!"
  exit 1
fi

# Check if the build directory exists
if [ ! -d "$BUILD_DIR" ]; then
  echo "Error: Build directory '$BUILD_DIR' not found!"
  echo "Creating directory"
  mkdir -p $BUILD_DIR
  echo "Created build directory '$BUILD_DIR'."
fi

# Copy the C file to the build directory
cp "$C_FILE" "$BUILD_DIR/"

# Navigate to the build directory
cd "$BUILD_DIR"

# Check if Android.bp exists in the build directory
if [ -f Android.bp ]; then
  echo "Updating Android.bp with $C_FILE..."
else
  echo "Creating Android.bp with $C_FILE..."
fi

# Create or update Android.bp
cat > Android.bp <<EOL
cc_binary {
    name: "$MODULE_NAME",
    srcs: ["$C_FILE"],
    shared_libs: ["libusb"],
    include_dirs: ["$INCLUDE_DIR"],  # Include libusb headers
    cflags: ["-Iexternal/libusb/libusb"],  # Include directory for libusb
    compile_multilib: "both",
    installable: true,
}
EOL

echo "Android.bp has been updated/created with $C_FILE in $BUILD_DIR."

# Navigate back to the AOSP root directory
cd "$HOME/shiba_debug/aosp"

