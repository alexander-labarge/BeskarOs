#!/bin/bash

# Base directory
BASE_DIR="aosp/vendor/thisistheway/silverball"

# Create directories
mkdir -p $BASE_DIR/service
mkdir -p $BASE_DIR/init

# Create and touch files
touch $BASE_DIR/Android.bp
touch $BASE_DIR/BoardConfig.mk
touch $BASE_DIR/service/SilverballBluetoothService.cpp
touch $BASE_DIR/service/SilverballBluetoothService.h
touch $BASE_DIR/service/ISilverballBluetoothService.aidl
touch $BASE_DIR/service/SilverballBluetoothRawAccess.cpp
touch $BASE_DIR/init/init.silverball.rc
touch $BASE_DIR/init/init.rc

# Write content to Android.bp
cat <<EOL > $BASE_DIR/Android.bp
cc_library {
    name: "libSilverballBluetoothService",
    vendor_available: true,
    srcs: [
        "service/SilverballBluetoothService.cpp",
        "service/SilverballBluetoothRawAccess.cpp",
    ],
    shared_libs: [
        "libbinder",
        "libhidlbase",
        "libhidltransport",
    ],
    cflags: [
        "-D__ANDROID_VNDK__",
    ],
}
EOL

# Write content to BoardConfig.mk
cat <<EOL > $BASE_DIR/BoardConfig.mk
BOARD_VENDOR_SERVICES := libSilverballBluetoothService
BOARD_VNDK_VERSION := current
EOL

# Write content to SilverballBluetoothService.cpp
cat <<EOL > $BASE_DIR/service/SilverballBluetoothService.cpp
#include <binder/IPCThreadState.h>
#include <binder/ProcessState.h>
#include <binder/IServiceManager.h>
#include <binder/Status.h>
#include "SilverballBluetoothService.h"

using namespace android;
using namespace com::thisistheway::silverball;

class SilverballBluetoothService : public BnSilverballBluetoothService {
public:
    static void instantiate() {
        defaultServiceManager()->addService(
            String16("silverball_bluetooth"), new SilverballBluetoothService());
    }

    status_t openBluetoothSocket() override {
        return ::android::com::thisistheway::silverball::openBluetoothSocket();
    }

    status_t sendRawHciPacket(const std::vector<uint8_t>& packet, std::vector<uint8_t>& response) override {
        return ::android::com::thisistheway::silverball::sendRawHciPacket(packet, response);
    }

private:
    int hci_socket = -1;
    std::mutex mtx;
};

int main(int argc, char** argv) {
    SilverballBluetoothService::instantiate();
    ProcessState::self()->startThreadPool();
    IPCThreadState::self()->joinThreadPool();
    return 0;
}
EOL

# Write content to SilverballBluetoothService.h
cat <<EOL > $BASE_DIR/service/SilverballBluetoothService.h
#ifndef COM_THISISTHEWAY_SILVERBALL_SILVERBALLBLUETOOTHSERVICE_H
#define COM_THISISTHEWAY_SILVERBALL_SILVERBALLBLUETOOTHSERVICE_H

#include <binder/IInterface.h>
#include <binder/Parcel.h>
#include <mutex>
#include <vector>

namespace android {
namespace com {
namespace thisistheway {
namespace silverball {

class ISilverballBluetoothService : public IInterface {
public:
    DECLARE_META_INTERFACE(SilverballBluetoothService);

    virtual status_t openBluetoothSocket() = 0;
    virtual status_t sendRawHciPacket(const std::vector<uint8_t>& packet, std::vector<uint8_t>& response) = 0;
};

class BnSilverballBluetoothService : public BnInterface<ISilverballBluetoothService> {
public:
    status_t onTransact(uint32_t code, const Parcel& data, Parcel* reply, uint32_t flags = 0) override;
};

// Functions to handle raw Bluetooth access
status_t openBluetoothSocket();
status_t sendRawHciPacket(const std::vector<uint8_t>& packet, std::vector<uint8_t>& response);

} // namespace silverball
} // namespace thisistheway
} // namespace com
} // namespace android

#endif // COM_THISISTHEWAY_SILVERBALL_SILVERBALLBLUETOOTHSERVICE_H
EOL

# Write content to ISilverballBluetoothService.aidl
cat <<EOL > $BASE_DIR/service/ISilverballBluetoothService.aidl
package com.thisistheway.silverball;

interface ISilverballBluetoothService {
    int openBluetoothSocket();
    int sendRawHciPacket(in byte[] packet, out byte[] response);
}
EOL

# Write content to SilverballBluetoothRawAccess.cpp
cat <<EOL > $BASE_DIR/service/SilverballBluetoothRawAccess.cpp
#include "SilverballBluetoothService.h"
#include <fcntl.h>
#include <unistd.h>
#include <errno.h>
#include <stdio.h>
#include <sys/socket.h>
#include <bluetooth/bluetooth.h>
#include <bluetooth/hci.h>
#include <bluetooth/hci_lib.h>
#include <mutex>
#include <vector>

using namespace android;
using namespace com::thisistheway::silverball;

namespace {
    int hci_socket = -1;
    std::mutex mtx;
}

status_t openBluetoothSocket() {
    std::lock_guard<std::mutex> lock(mtx);

    if (hci_socket >= 0) {
        return NO_ERROR;  // Socket already opened
    }

    // Create a socket for HCI
    hci_socket = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
    if (hci_socket < 0) {
        perror("Failed to create HCI socket");
        return -errno;
    }

    // Open the first available Bluetooth adapter
    int dev_id = hci_get_route(NULL);
    if (dev_id < 0) {
        perror("No available Bluetooth adapter");
        close(hci_socket);
        hci_socket = -1;
        return -errno;
    }

    // Bind the socket to the adapter
    struct sockaddr_hci addr;
    addr.hci_family = AF_BLUETOOTH;
    addr.hci_dev = dev_id;
    addr.hci_channel = HCI_CHANNEL_RAW;
    if (bind(hci_socket, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
        perror("Failed to bind HCI socket");
        close(hci_socket);
        hci_socket = -1;
        return -errno;
    }

    return NO_ERROR;
}

status_t sendRawHciPacket(const std::vector<uint8_t>& packet, std::vector<uint8_t>& response) {
    std::lock_guard<std::mutex> lock(mtx);

    if (hci_socket < 0) {
        fprintf(stderr, "HCI socket is not opened\n");
        return -ENODEV;
    }

    // Send the HCI packet
    if (write(hci_socket, packet.data(), packet.size()) < 0) {
        perror("Failed to send HCI packet");
        return -errno;
    }

    // Read the response
    uint8_t buf[HCI_MAX_EVENT_SIZE];
    ssize_t len = read(hci_socket, buf, sizeof(buf));
    if (len < 0) {
        perror("Failed to read HCI response");
        return -errno;
    }

    response.assign(buf, buf + len);

    return NO_ERROR;
}
EOL

# Write content to init.silverball.rc
cat <<EOL > $BASE_DIR/init/init.silverball.rc
service vendor.bluetooth /vendor/bin/hw/vendor.bluetooth
    class main
    user bluetooth
    group bluetooth net_bt_admin net_bt
    disabled
    oneshot
EOL

# Write content to init.rc
cat <<EOL > $BASE_DIR/init/init.rc
on boot
    start vendor.bluetooth
EOL

# Ensure the package is added to the allowed list
PACKAGE_LIST_FILE="build/soong/scripts/check_boot_jars/package_allowed_list.txt"
PACKAGE_NAME="com.thisistheway.silverball"

if [ ! -f $PACKAGE_LIST_FILE ]; then
    echo "Error: package_allowed_list.txt not found!"
    exit 1
fi

if ! grep -q "$PACKAGE_NAME" $PACKAGE_LIST_FILE; then
    echo "$PACKAGE_NAME" >> $PACKAGE_LIST_FILE
    echo "Package $PACKAGE_NAME added to the allowed list"
else
    echo "Package $PACKAGE_NAME already in the allowed list"
fi

echo "Directory structure and files created successfully."
