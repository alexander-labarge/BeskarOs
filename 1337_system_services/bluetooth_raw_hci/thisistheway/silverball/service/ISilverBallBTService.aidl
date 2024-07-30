package com.thisistheway.silverball;

import com.thisistheway.silverball.ISilverBallBTCallback;

interface ISilverBallBTService {
    void sendRawHciCommand(in byte[] command);
    void registerCallback(in ISilverBallBTCallback callback);
}
