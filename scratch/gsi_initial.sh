fastboot erase system
fastboot flash system system.img
fastboot --disable-verity --disable-verification flash vbmeta vbmeta.img

# Add Google's Android Repository
echo "deb [arch=amd64] https://repo.google.com/apt/cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt-get update