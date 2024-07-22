#!/bin/bash

mkdir -p ~/shiba_debug/aosp
cd ~/shiba_debug/aosp
echo "Create a password with the password generator to bypass rate-limits"
# Open the link in a browser and a new terminal
xdg-open https://android.googlesource.com/new-password
# user to press enter in the original terminal after copy pastee
read -p "Copy Google's Password Script as a Command into the Terminal and then Hit Enter:"
echo "Downloading Android Source Code"
sleep 2
# dev note: android build tag - latest stable - android-14.0.0_r54 (5 Jul 24 release)
repo init --partial-clone -b android-14.0.0_r54 -u https://android.googlesource.com/platform/manifest
repo sync -c -j$(nproc --all)
echo "Android Source Download Complete"
sleep 2
echo "Source code located at: ~/shiba_debug/aosp"
# how it should look:
# skywalker@4090-nvidia-dev:~/beskaros/0_env_setup$ ls -lah ~/shiba_debug/aosp/
# total 116K
# drwxrwxr-x  25 skywalker skywalker 4.0K Jul 22 13:25 .
# drwxrwxr-x   3 skywalker skywalker 4.0K Jul 22 13:21 ..
# lrwxrwxrwx   1 skywalker skywalker   19 Jul 22 13:23 Android.bp -> build/soong/root.bp
# drwxrwxr-x  38 skywalker skywalker 4.0K Jul 22 13:23 art
# drwxrwxr-x  14 skywalker skywalker 4.0K Jul 22 13:23 bionic
# drwxrwxr-x   4 skywalker skywalker 4.0K Jul 22 13:23 bootable
# lrwxrwxrwx   1 skywalker skywalker   26 Jul 22 13:23 bootstrap.bash -> build/soong/bootstrap.bash
# drwxrwxr-x  10 skywalker skywalker 4.0K Jul 22 13:23 build
# lrwxrwxrwx   1 skywalker skywalker   23 Jul 22 13:23 BUILD -> build/bazel/bazel.BUILD
# drwxrwxr-x  14 skywalker skywalker 4.0K Jul 22 13:25 cts
# drwxrwxr-x   7 skywalker skywalker 4.0K Jul 22 13:25 dalvik
# drwxrwxr-x   5 skywalker skywalker 4.0K Jul 22 13:25 developers
# drwxrwxr-x   2 skywalker skywalker 4.0K Jul 22 13:25 development
# drwxrwxr-x   6 skywalker skywalker 4.0K Jul 22 13:23 device
# drwxrwxr-x 414 skywalker skywalker  16K Jul 22 13:25 external
# drwxrwxr-x  16 skywalker skywalker 4.0K Jul 22 13:25 frameworks
# drwxrwxr-x  16 skywalker skywalker 4.0K Jul 22 13:23 hardware
# drwxrwxr-x   4 skywalker skywalker 4.0K Jul 22 13:23 kernel
# -r--r--r--   1 skywalker skywalker  652 Jul 22 13:23 lk_inc.mk
# drwxrwxr-x   9 skywalker skywalker 4.0K Jul 22 13:24 packages
# drwxrwxr-x   5 skywalker skywalker 4.0K Jul 22 13:23 pdk
# drwxrwxr-x  11 skywalker skywalker 4.0K Jul 22 13:23 platform_testing
# drwxrwxr-x  10 skywalker skywalker 4.0K Jul 22 13:24 prebuilts
# drwxrwxr-x   7 skywalker skywalker 4.0K Jul 22 13:23 .repo
# drwxrwxr-x  29 skywalker skywalker 4.0K Jul 22 13:23 system
# drwxrwxr-x  13 skywalker skywalker 4.0K Jul 22 13:24 test
# drwxrwxr-x   3 skywalker skywalker 4.0K Jul 22 13:24 toolchain
# drwxrwxr-x  29 skywalker skywalker 4.0K Jul 22 13:24 tools
# drwxrwxr-x   9 skywalker skywalker 4.0K Jul 22 13:24 trusty
# lrwxrwxrwx   1 skywalker skywalker   27 Jul 22 13:23 WORKSPACE -> build/bazel/bazel.WORKSPACE
# skywalker@4090-nvidia-dev:~/beskaros/0_env_setup$ 



