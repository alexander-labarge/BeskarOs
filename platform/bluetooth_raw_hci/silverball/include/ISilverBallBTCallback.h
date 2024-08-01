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
