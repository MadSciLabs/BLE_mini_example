#include "testApp.h"
#include "ofxBLE.h"

bool bFirstTime = true;
int counter =0;

//--------------------------------------------------------------
void testApp::setup(){	
	ofxiPhoneSetOrientation(OFXIPHONE_ORIENTATION_PORTRAIT);
	
	//this is to scale down the example for the iphone screen
	appIphoneScale = 0.5;

	ofBackground(255,255,255);	
	ofSetFrameRate(60);

    myBLe = new ofxBLE();
    
    // setups callbacks / listener
    myBLe->setDataDelegate(this);
    
    myBLe->scanPeripherals();
    
    btn.setup(ofRectangle(50, 50, 50, 50));
    btn2.setup(ofRectangle(180, 50, 40, 40));

    
    prevDATA = 0;
}


//--------------------------------------------------------------
void testApp::update(){
    
    
    
    if (bFirstTime) {
        myBLe->scanPeripherals();

        counter++;
        
        if (counter > 2) {
            bFirstTime = false;
        }
    }

    
//    if (! myBLe->isConnected()) {
//        myBLe->scanPeripherals();
//    }
}

//--------------------------------------------------------------
void testApp::draw(){

    btn.draw();
    btn2.draw();
    
    float mappedValue = ofMap(value, 0, 688, 0, 480);
    
    ofSetColor(255, 0, 0);
    ofCircle(200, mappedValue, 30);
    
    
    ofSetColor(0);
    if (myBLe->isConnected()) ofSetColor(0, 255, 0);
    ofTriangle(0, 0, 40, 0, 0, 40);

}

//--------------------------------------------------------------
void testApp::exit(){
    
}

//--------------------------------------------------------------
void testApp::touchDown(ofTouchEventArgs & touch){
    btn.onPress(ofPoint(touch.x, touch.y));
    btn2.onPress(ofPoint(touch.x, touch.y));
                 
}

//--------------------------------------------------------------
void testApp::touchMoved(ofTouchEventArgs & touch){
    float val = ofMap(touch.x, 0, ofGetHeight(), 0, 225, true);
    myBLe->sendServo(val);
}

//--------------------------------------------------------------
void testApp::touchUp(ofTouchEventArgs & touch){
    
    btn.onRelease();
    myBLe->sendDigitalOut(btn.bState);
    

}

//--------------------------------------------------------------
void testApp::touchDoubleTap(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::touchCancelled(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void testApp::lostFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotFocus(){
    
}

//--------------------------------------------------------------
void testApp::gotMemoryWarning(){
    
}

//--------------------------------------------------------------
void testApp::deviceOrientationChanged(int newOrientation){
    
}

// Because test app is our new data delegate
void testApp::didRecieveData(unsigned char * data, int length)
{
    //NSLog(@"got some dataz of length %i", length);
    for (int i = 0; i < length; i+=3)
    {
        //NSLog(@"0x%02X, 0x%02X, 0x%02X", data[i], data[i+1], data[i+2]);
        
        if (data[i] == 0x0A)
        {
            //            if (data[i+1] == 0x01)
            //                swDigitalIn.on = true;
            //            else
            //                swDigitalIn.on = false;
        }
        else if (data[i] == 0x0B)
        {
            
            value = data[i+2] | data[i+1] << 8;
           // cout <<" analog data uhuuuuuu:::: "<< Value<<endl;
            //lblAnalogIn.text = [NSString stringWithFormat:@"%d", Value];
        }
    }
}
