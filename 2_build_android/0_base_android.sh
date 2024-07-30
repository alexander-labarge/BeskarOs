#!/bin/bash

# cd to android home
cd ~/shiba_debug/aosp

# Setup environment
source build/envsetup.sh

# Generate keys
subject='/C=US/ST=State/L=City/O=Android/OU=Android/CN=Android/emailAddress=email@example.com'
mkdir -p vendor/aosp/signing/keys
for x in releasekey platform shared media networkstack verity otakey testkey sdk_sandbox bluetooth nfc; do
    ./development/tools/make_key vendor/aosp/signing/keys/$x "$subject"
done

# Copy keys to security directory
cp vendor/aosp/signing/keys/* ./build/target/product/security/

# Lunch target and build
lunch aosp_shiba-ap1a-userdebug
#aosp_shiba-trunk_staging-eng
m -j$(nproc --all)