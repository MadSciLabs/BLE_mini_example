#pragma once

#include "ofMain.h"
#include "ofxiPhone.h"
#include "ofxiPhoneExtras.h"


#include "rxGui_Toggle.h"
class ofxBLE;

class testApp : public ofxiPhoneApp {
	
    public:
        void setup();
        void update();
        void draw();
        void exit();
    
        void touchDown(ofTouchEventArgs & touch);
        void touchMoved(ofTouchEventArgs & touch);
        void touchUp(ofTouchEventArgs & touch);
        void touchDoubleTap(ofTouchEventArgs & touch);
        void touchCancelled(ofTouchEventArgs & touch);
	
        void lostFocus();
        void gotFocus();
        void gotMemoryWarning();
        void deviceOrientationChanged(int newOrientation);

    // delegate / listener shit
    void didRecieveData(unsigned char * data, int length);

    
        float appIphoneScale;
    ofxBLE* myBLe;
    unsigned char* prevDATA;
    
    rxGui_Toggle btn, btn2;
    UInt16 value;

    
};


