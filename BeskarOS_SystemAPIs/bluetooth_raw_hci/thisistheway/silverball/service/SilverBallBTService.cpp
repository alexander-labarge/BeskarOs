#include "SilverBallBTService.h"
#include <android/log.h>
#include <fcntl.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

#define LOG_TAG "SilverBallBTService"

using namespace com::thisistheway::silverball;

SilverBallBTService::SilverBallBTService() {
    ALOGD("SilverBallBTService created");
}

SilverBallBTService::~SilverBallBTService() {
    ALOGD("SilverBallBTService destroyed");
}

void SilverBallBTService::sendRawHciCommand(const std::vector<uint8_t>& command) {
    int sock = socket(AF_BLUETOOTH, SOCK_RAW, BTPROTO_HCI);
    if (sock < 0) {
        ALOGE("Failed to create HCI socket");
        return;
    }

    struct sockaddr_hci addr;
    memset(&addr, 0, sizeof(addr));
    addr.hci_family = AF_BLUETOOTH;
    addr.hci_dev = 0; // Use the first available Bluetooth device
    addr.hci_channel = HCI_CHANNEL_RAW;

    if (bind(sock, (struct sockaddr*)&addr, sizeof(addr)) < 0) {
        ALOGE("Failed to bind HCI socket");
        close(sock);
        return;
    }

    if (write(sock, command.data(), command.size()) < 0) {
        ALOGE("Failed to send HCI command");
    }

    close(sock);
}

void SilverBallBTService::registerCallback(const android::sp<ISilverBallBTCallback>& callback) {
    mCallback = callback;
}
