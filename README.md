![beskaros_logo](https://github.com/user-attachments/assets/3c4e0b07-caf6-4050-82b4-244c8bd60103)
<img src="https://github.com/user-attachments/assets/3c4e0b07-caf6-4050-82b4-244c8bd60103" alt="beskaros_logo" width="300"/>
## Software Development Plan & Initial Documentation

### Project Start Date:
- 29 Jul 24

### Project Purpose and Motivation:

The primary motivation for developing BeskarOS stems from the current limitation in public release Android builds, which do not provide raw socket access to USB, Bluetooth, Radio, and Network stack hardware. This limitation restricts developers and advanced users from fully leveraging the hardware capabilities for specialized applications and low-level communication tasks. BeskarOS aims to bridge this gap by offering raw socket access through custom AIDL interfaces and new system-level services, all while maintaining robust Android security practices, including SELinux enforcement. These significant deviations from standard Android merit a full custom Android ROM to relock the bootloader and ensure device integrity. Additionally, we seek to ensure encrypted communication over both radio and any networked interface as soon as the device boots and control the public fingerprint of the device to ensure it looks like any other Android phone.

The custom build of BeskarOS will also include the 6.6 Long Term Release (LTR) kernel custom-tailored for use cases with Android, which offers several benefits over the currently used (by Android Mainline) 5.15 kernel. The 6.6 LTR kernel provides enhanced performance, better security features, improved hardware support, and more efficient power management, which are critical for secure, modern Android devices. These improvements will help ensure that BeskarOS is more robust, secure, and efficient than any commercially available distribution.

Reference (Android 15 Preview uses Kernel version 5.15 from 2021):
- [Kernel Releases](https://www.kernel.org/category/releases.html)

### Table of Contents
1. [Project Scope](#project-scope)
2. [Requirements](#requirements)
3. [System Architecture](#system-architecture)
4. [Development Environment](#development-environment)
5. [Development Phases](#development-phases)
6. [Security Considerations](#security-considerations)
7. [Testing and Quality Assurance](#testing-and-quality-assurance)
8. [Deployment](#deployment)
9. [Documentation](#documentation)
10. [Timeline and Milestones](#timeline-and-milestones)

### Project Scope

**Objective**: Create BeskarOS, an Android-based custom ROM with raw socket access to specific hardware components.

**Target Version**: beta-0.1.0

**Primary Features**:
- Raw socket access to USB, Bluetooth, Radio, and Network stack hardware.
- Custom AIDL interfaces for each hardware component.
- New system-level services to manage raw socket access.
- Compliance with Android security practices, including SELinux.
- Custom signing keys for the ROM build.

### Requirements

**Functional Requirements**:
- Implement raw socket access for USB, Bluetooth, Radio, and Network hardware.
- Develop custom AIDL interfaces for hardware communication.
- Create system-level services to expose raw socket access via AIDL.
- Ensure seamless integration with existing Android frameworks.

**Non-Functional Requirements**:
- Maintain system security and integrity.
- Ensure performance and responsiveness of system services.
- Provide comprehensive logging and monitoring capabilities.

**Hardware Requirements**:
- Support for a range of Android-compatible hardware platforms.
- Testing devices: List of specific devices to be supported in version 0.1.0.

### System Architecture

**High-Level Architecture**:
- Kernel Layer: Modify kernel to support raw socket access.
- HAL Layer: Update Hardware Abstraction Layer to expose raw socket interfaces.
- System Services: Implement new system services using AIDL for USB, Bluetooth, Radio, and Network access.
- Security Layer: Integrate SELinux policies and other security mechanisms to safeguard raw socket access.

**Components**:
- **Kernel Modifications**:
  - Add support for raw socket access.
  - Ensure compatibility with Android's existing kernel.
- **HAL Modifications**:
  - Extend HAL to support new raw socket APIs.
  - Implement hardware-specific drivers if necessary.
- **System Services**:
  - Develop AIDL interfaces for USB, Bluetooth, Radio, and Network.
  - Implement system services to handle AIDL requests and manage hardware access.
- **Security**:
  - Define SELinux policies to secure new system services.
  - Implement additional security measures as needed.

### Development Environment

**Tools and Technologies**:
- Android Open Source Project (AOSP) repository.
- Android Studio for development.
- Git for version control.
- Custom signing keys for ROM builds.
- Emulators and physical devices for testing.

**Development Setup**:
- Set up the development environment with the required tools and dependencies.
- Clone and set up the AOSP repository.
- Configure build environment for target devices.

### Development Phases

**Week 1: Initial Release and Core Development**
- Planning and Design: Betaize detailed requirements and high-level design.
- Initial Implementation: 
  - Basic kernel modifications for raw socket support.
  - Initial HAL updates to expose raw socket interfaces.
  - Development of SilverBallBluetoothService:
    - Implement AIDL interfaces for Bluetooth.
    - Implement system service to send raw HCI packets to the Bluetooth controller.
  - Development of Grogu APK:
    - User interface to interact with SilverBallBluetoothService.
    - Functionality to send and receive raw HCI packets.
- Initial Build: Compile and release the initial version (v0.1.0-alpha).

**Week 2: USB Stack Development**
- Kernel and HAL Enhancements: Refine kernel and HAL implementations for USB.
- AIDL Interfaces: Complete AIDL interfaces for USB.
- System Services: Develop and integrate system service for USB raw socket access.
- Patch Release: Compile and release updated version (v0.1.0-beta1).

**Week 3: Radio Stack Development**
- Kernel and HAL Enhancements: Refine kernel and HAL implementations for Radio.
- AIDL Interfaces: Complete AIDL interfaces for Radio.
- System Services: Develop and integrate system service for Radio raw socket access.
- Patch Release: Compile and release updated version (v0.1.0-beta2).

**Week 4: Network Stack Development and Betaization**
- Kernel and HAL Enhancements: Refine kernel and HAL implementations for Network.
- AIDL Interfaces: Complete AIDL interfaces for Network.
- System Services: Develop and integrate system service for Network raw socket access.
- Security Implementations: Define and enforce SELinux policies and other security measures.
- Performance Optimization: Optimize system services for performance and responsiveness.
- Beta Integration: Ensure all components are fully integrated and functioning.
- Quality Assurance: Conduct Beta testing, including unit, integration, system, and security tests.
- Documentation: Prepare and Betaize technical documentation and user guides.
- Beta Release: Compile, sign, and release the Beta version (v0.1.0).

### Security Considerations

- **SELinux Policies**: Define and enforce SELinux policies for new services.
- **Access Control**: Implement strict access control mechanisms for raw socket access.
- **Data Encryption**: Ensure data transmitted over raw sockets is encrypted.
- **Security Audits**: Conduct regular security audits and vulnerability assessments.

### Testing and Quality Assurance

- **Unit Testing**: Test individual components and services.
- **Integration Testing**: Test interactions between components.
- **System Testing**: Test the entire system on target devices.
- **Performance Testing**: Evaluate performance and responsiveness.
- **Security Testing**: Conduct penetration testing and security assessments.

### Deployment

- **Build Process**: Compile the ROM with custom signing keys.
- **Distribution**: Provide installation packages for supported devices.
- **Feedback Loop**: Gather feedback from early adopters and testers.

### Documentation

- **Developer Documentation**: Technical details for developers.
- **User Guides**: Instructions for installation and usage.
- **API Documentation**: Details of AIDL interfaces and system services.

### Timeline and Milestones

- **Week 1**: Initial release with SilverBallBluetoothService and Grogu APK.
- **Week 2**: USB stack development and integration.
- **Week 3**: Radio stack development and integration.
- **Week 4**: Network stack development, Beta testing, documentation, and deployment.

### Notes:

- **TODO - Kernel Configuration to support raw access we need**:

```sh
CONFIG_BT=y
CONFIG_BT_HCIBTUSB=y
CONFIG_BT_HCIUART=y
CONFIG_BT_RFCOMM=y
CONFIG_BT_BNEP=y
CONFIG_BT_HIDP=y
CONFIG_BT_RAW=y
```

### SilverBallBluetoothService

This section provides an overview of the implementation of the SilverBallBluetoothService, which enables raw HCI communication with Bluetooth controllers in BeskarOS. The service consists of several components, including AIDL interfaces, C++ implementations, and integration into the Android build system. 

#### Directory Structure

The directory structure for the SilverBallBluetoothService is as follows:

```sh
skywalker@deathstar:~/beskaros$ tree -L 5
.
├── apps
│   ├── README.md
│   ├── system
│   │   └── README.md
│   └── user
│       └── README.md
├── build
│   ├── 0_env_setup
│   │   ├── 0_ubuntu_22_04_base.sh
│   │   ├── 1_install_newest_adb_fastboot.sh
│   │   ├── 2_install_android_build_tools.sh
│   │   ├── 3_get_android_source_code.sh
│   │   └── ubuntu_22.04_packages_required.txt
│   ├── 1_pixel_8_firmware
│   │   └── 0_get_latest_pixel8_preview_binaries.sh
│   └── 2_compile_base_android
│       └── 0_base_android.sh
├── cloudcityvm
│   └── README.md
├── hardware
│   └── README.md
├── installer
│   ├── beskar_flash.sh
│   ├── factory_flash.sh
│   ├── fastboot_adb_latest_install.sh
│   ├── README.md
│   ├── system.img
│   └── vbmeta.img
├── kernel
│   └── README.md
├── LICENSE
├── patches
│   └── README.md
├── platform
│   ├── bluetooth_raw_hci
│   │   └── silverball
│   │       ├── Android.bp
│   │       ├── BoardConfig.mk
│   │       ├── include
│   │       │   ├── ISilverBallBTCallback.h
│   │       │   └── SilverBallBTService.h
│   │       └── service
│   │           ├── ISilverBallBTCallback.aidl
│   │           ├── ISilverBallBTCallback.cpp
│   │           ├── ISilverBallBTService.aidl
│   │           ├── SilverBallBTCallback.cpp
│   │           └── SilverBallBTService.cpp
│   └── README.md
├── python
│   └── README.md
├── README.md
├── selinux
│   └── README.md
├── system
│   └── README.md
├── user
│   └── README.md
└── vendor
    └── README.md

22 directories, 37 files
```
#### Build Configuration

The build configuration for the SilverBallBluetoothService is defined in `Android.bp` and `BoardConfig.mk`.

**Android.bp:**

```sh
// vendor/thisistheway/silverball/Android.bp
cc_library {
    name: "libSilverballBluetoothService",
    vendor_available: true,
    system_ext_specific: true,
    srcs: [
        "service/SilverBallBTService.cpp",
        "service/ISilverBallBTCallback.cpp",
    ],
    shared_libs: [
        "libbinder",
    ],
    cflags: [
        "-D__ANDROID_VNDK__",
    ],
    export_include_dirs: ["include"],
}
```

This `Android.bp` file specifies the build configuration for the SilverBallBluetoothService library. It includes source files, shared libraries, and compiler flags required for the build.

**BoardConfig.mk:**

```sh
BOARD_VENDOR_SERVICES := libSilverballBluetoothService
BOARD_VNDK_VERSION := current
```

The `BoardConfig.mk` file defines the vendor services and the VNDK version.

#### AIDL Interfaces

The AIDL interfaces define the contract for communication between the client and the service.

**ISilverBallBTCallback.aidl:**

```sh
package com.thisistheway.silverball;

interface ISilverBallBTCallback {
    void onHciEventReceived(in byte[] event);
}
```

The `ISilverBallBTCallback.aidl` file defines the callback interface for receiving HCI events.

**ISilverBallBTService.aidl:**

```sh
package com.thisistheway.silverball;

import com.thisistheway.silverball.ISilverBallBTCallback;

interface ISilverBallBTService {
    void sendRawHciCommand(in byte[] command);
    void registerCallback(in ISilverBallBTCallback callback);
}
```

The `ISilverBallBTService.aidl` file defines the service interface for sending raw HCI commands and registering callbacks.

#### Header Files

The header files define the C++ interfaces for the callback and service classes.

**ISilverBallBTCallback.h:**

```sh
#ifndef COM_THISISTHEWAY_SILVERBALL_ISILVERBALLBTCALLBACK_H
#define COM_THISISTHEWAY_SILVERBALL_ISILVERBALLBTCALLBACK_H

#include <binder/IInterface.h>
#include <vector>

namespace com {
namespace thisistheway {
namespace silverball {

class ISilverBallBTCallback : public android::IInterface {
public:
    DECLARE_META_INTERFACE(SilverBallBTCallback);
    virtual void onHciEventReceived(const std::vector<uint8_t>& event) = 0;
};

class BnSilverBallBTCallback : public android::BnInterface<ISilverBallBTCallback> {
public:
    virtual android::status_t onTransact(uint32_t code, const android::Parcel& data,
                                         android::Parcel* reply, uint32_t flags = 0);
};

} // namespace silverball
} // namespace thisistheway
} // namespace com

#endif // COM_THISISTHEWAY_SILVERBALL_ISILVERBALLBTCALLBACK_H
```

**SilverBallBTService.h:**

```sh
#ifndef COM_THISISTHEWAY_SILVERBALL_SILVERBALLBTSERVICE_H
#define COM_THISISTHEWAY_SILVERBALL_SILVERBALLBTSERVICE_H

#include <vector>
#include <binder/BinderService.h>
#include "ISilverBallBTService.h"

namespace com {
namespace thisistheway {
namespace silverball {

class SilverBallBTService : public android::BinderService<SilverBallBTService>,
                            public BnSilverBallBTService {
public:
    SilverBallBTService();
    virtual ~SilverBallBTService();

    static const char* getServiceName() { return "SilverBallBTService"; }
    virtual void sendRawHciCommand(const std::vector<uint8_t>& command);
    virtual void registerCallback(const android::sp<ISilverBallBTCallback>& callback);

private:
    android::sp<ISilverBallBTCallback> mCallback;
};

} // namespace silverball
} // namespace thisistheway
} // namespace com

#endif // COM_THISISTHEWAY_SILVERBALL_SILVERBALLBTSERVICE_H
```

#### C++ Implementations

The C++ implementations define the logic for the callback and service classes.

**ISilverBallBTCallback.cpp:**

```sh
#include "ISilverBallBTCallback.h"
#include <binder/Parcel.h>

using namespace com::thisistheway::silverball;

IMPLEMENT_META_INTERFACE(SilverBallBTCallback, "com.thisistheway.silverball.ISilverBallBTCallback");

android::status_t BnSilverBallBTCallback::onTransact(uint32_t code, const android::Parcel& data,
                                                     android::Parcel* reply, uint32_t flags) {
    switch (code) {
        case 0: {
            std::vector<uint8_t> event;
            data.readByteVector(&event);
            onHciEventReceived(event);
            return android::NO_ERROR;
        }
        default:
            return BBinder::onTransact(code, data, reply, flags);
    }
}
```

**SilverBallBTService.cpp:**

```sh
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
```

#### Summary

- **Build Configuration**: The `Android.bp` and `BoardConfig.mk` files configure the build for the SilverBallBluetoothService library, specifying source files, shared libraries, and compiler flags.
- **AIDL Interfaces**: The `ISilverBallBTCallback.aidl` and `ISilverBallBTService.aidl` files define the AIDL interfaces for callback and service communication.
- **Header Files**: The `ISilverBallBTCallback.h` and `SilverBallBTService.h` files define the C++ interfaces for the callback and service classes.
- **C++ Implementations**: The `ISilverBallBTCallback.cpp` and `SilverBallBTService.cpp` files implement the logic for handling HCI events and managing raw HCI communication with the Bluetooth controller.
```