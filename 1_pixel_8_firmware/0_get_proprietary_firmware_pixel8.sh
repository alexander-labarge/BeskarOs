#!/bin/bash

echo "Getting Proprietary Firmware from Google for the Pixel 8"
# change directory to build home
cd ~/shiba_debug/aosp

wget https://dl.google.com/dl/android/aosp/google_devices-shiba-ap2a.240705.005.a1-2f02e090.tgz
bsdtar xvf google_devices-shiba-ap2a.240705.005.a1-2f02e090.tgz

# note: this unpacks the vendor and driver binaries where needed
# hard part of bootloader build codes is done - it will just work
./extract-google_devices-shiba.sh

echo "Firmware Obtained and Extracted - Success."
sleep 2