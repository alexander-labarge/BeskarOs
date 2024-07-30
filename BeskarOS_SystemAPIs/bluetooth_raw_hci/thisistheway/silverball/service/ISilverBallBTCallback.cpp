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
