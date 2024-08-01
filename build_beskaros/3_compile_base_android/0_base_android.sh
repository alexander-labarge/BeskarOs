#!/bin/bash

# cd to android home
cd /mnt/android/beskaros

# Setup environment
source build/envsetup.sh

# Generate keys
subject='/C=US/ST=PA/L=Philadelphia/O=This/OU=is/CN=TheWay/emailAddress=alex@labarge.dev'
mkdir -p vendor/aosp/signing/keys
for x in releasekey platform shared media networkstack verity otakey testkey sdk_sandbox bluetooth nfc; do
    ./development/tools/make_key vendor/aosp/signing/keys/$x "$subject"
done

# Copy keys to security directory
cp vendor/aosp/signing/keys/* ./build/target/product/security/

# Lunch target and build
lunch aosp_shiba-trunk_staging-userdebug
#aosp_shiba-trunk_staging-eng
m -j$(nproc --all)
