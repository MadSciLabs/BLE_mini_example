//
//  ofxBLE.h
//  blebleble
//
//  Created by Rui Pereira on 3/19/13.
//
//

#pragma once
#import "testApp.h"

#import "BLE.h"
#include "ofMain.h"


@interface ofxBLEDelegate : NSObject <BLEDelegate>
{
    BLE *ble;
}

@property (assign, atomic) testApp* dataDelegate;
@property (strong, nonatomic)   BLE *ble;
@property unsigned char * receivedDATA;
@property int lengthOfDATA;

@end


class ofxBLE{
protected:
    ofxBLEDelegate *dongle;

public:
    //constructor
    ofxBLE();
    //destructor
    ~ofxBLE();
    
    void update();
    void scanPeripherals();
    void sendDigitalOut(bool bState);
    void setAnalogInput(bool bState);
    void setDataDelegate(testApp* delegate);
    //void getData();
    void sendServo(float _val);
    
    int analogVAL;
    unsigned char * receivedDATA;
    int lengthOfDATA;
    
    bool isConnected();
};


