//
//  rxGui_Toggle.h
//  blebleble
//
//  Created by Rui Pereira on 3/28/13.
//
//

#ifndef _rxGui_Toggle__
#define _rxGui_Toggle__

#include "ofMain.h"


class rxGui_Toggle{
public:
    
    void setup(ofRectangle _rect){
        
        rect = _rect;
        bActive = false;
        bState = false;
    };
    
    void draw(){
        
        if (bState) ofSetColor(0, 255, 0);
        else ofSetColor(255, 0, 0);
        
        ofRect(rect);
    };
    
    void onPress(ofPoint xy){
        
        if (rect.inside(xy)) bActive = true;
        
    };
    void onRelease(){
        if (bActive) {
            bState =! bState;
            bActive = false;
        }
    };
    
    ofRectangle rect;
    bool bState;
    bool bActive;
    


};
#endif