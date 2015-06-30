#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxGui.h"
#include "iOSDevice.h"

class ofApp : public ofxiOSApp {

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
    
    int TOUCH_NUM = 5;
    
    
    
    vector<ofPoint> touchedPos;
    vector<ofPoint> preTouchedPos;
    vector<bool> bTouching;
    vector<bool> bMoving;
    
    ofxPanel gui;
    ofxColorSlider colorSlider;
    ofxIntSlider lineSizeSlider;
    ofxIntSlider resampleNumSlider;
    ofxIntSlider bgArphaSlider;
    
    ofFbo mFbo;
    
    bool bShowGui;
    
};


