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
