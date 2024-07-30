#include "ISilverBallBTService.h"
#include <binder/Parcel.h>

using namespace com::thisistheway::silverball;

IMPLEMENT_META_INTERFACE(SilverBallBTCallback, "com.thisistheway.silverball.ISilverBallBTCallback");

status_t BnSilverBallBTService::onTransact(uint32_t code, const Parcel& data,
                                           Parcel* reply, uint32_t flags) {
    switch (code) {
    case SEND_RAW_HCI_COMMAND: {
        std::vector<uint8_t> command;
        data.readByteVector(&command);
        sendRawHciCommand(command);
        return NO_ERROR;
    }
    case REGISTER_CALLBACK: {
        sp<ISilverBallBTCallback> callback = interface_cast<ISilverBallBTCallback>(data.readStrongBinder());
        registerCallback(callback);
        return NO_ERROR;
    }
    default:
        return BBinder::onTransact(code, data, reply, flags);
    }
}
