#!/bin/bash

# cd to android home
cd ~/shiba_debug/aosp

# Setup environment
source build/envsetup.sh

# Generate keys
subject='/C=US/ST=Pennsylvania/L=Eastern/O=Skywalker/OU=TrollyFactory/CN=Android/emailAddress=alex@labarge.dev'
mkdir -p ~/.android-certs
for x in releasekey platform shared media networkstack; do
    ./development/tools/make_key ~/.android-certs/$x "$subject"
done

# Copy keys to security directory
cp ~/.android-certs/* ./build/target/product/security/

# Lunch target and build
lunch aosp_shiba-ap1a-userdebug
m -j$(nproc --all)
