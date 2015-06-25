#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "LibPd.h"
#include "iOSDevice.h"
#include "ofxCoreMotion.h"
#include "ofxGui.h"
#include "mySlider.h"
#include "DraggableButton.h"

class FingerTrace;

class ofApp : public ofxiOSApp {
    
    int FINGER_NUM;
    static const int PRESSURE_NUM = 21;
    
    
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
    
    ////************** sound
    void audioReceived(float * input, int bufferSize, int nChannels);
    void audioRequested(float * output, int bufferSize, int nChannels);
    LibPd mLibPd;
    
    vector<int> timeStamp; //count time from last touchMoved
    vector<float> note;
    vector<float> freq;
    vector<float> volume;
    
    ofxCoreMotion coreMotion;
    ofVec3f g;
    float preGyroSum;
    ofxFloatSlider minThreshold;
    ofxFloatSlider maxThreshold;
    
    ofxFloatSlider maxFeedback;
    ofxFloatSlider delayTime;
    ofxFloatSlider delayDecay;
    void onChangedDelayTime(float &f);
    void onChangedDelayDecay(float &f);
    float beginRoll;
    bool bShowGui;
    bool bSwinged;
    
    ////************ image
    static const int barNum = 5;
    DraggableButton *brailleBar[barNum];
    void onButtonTouchDown(draggableButtonArgs &btnTouch);
    void onButtonTouchMoved(draggableButtonArgs &btnTouch);
    void onButtonTouchUp(draggableButtonArgs &btnTouch);
    
    vector<FingerTrace *> mFingerTraces;
    ofxColorSlider drawColor;
    ofImage img;
    
    vector<mySlider *> mMySliderVec;
    
    
    ofxPanel gui;
    ofxIntSlider bgAlpha;
    
    ofColor bgColor = ofColor(0);
    
    int minDist = 2;
    int maxDist = 200;
    
    int minNote = 36;
    int maxNote = 72;
    int minFreq = 60;
    int maxFreq = 880;
    
    int pressureValues[PRESSURE_NUM] =
    {
        12.757812,
        25.524292,
        38.290771,
        51.048584,
        63.815063,
        76.581543,
        89.348022,
        102.105835,
        114.872314,
        127.638794,
        140.396606,
        153.163086,
        165.929565,
        178.696045,
        191.453857,
        204.220337,
        216.986816,
        229.744629,
        242.511108,
        255.277588,
        268.044067
    };
    
    
    ///
    int screenWidth;
    int screenHeight;
    bool isiOS8;
    void setOrientationLandscape();
};

/* 
 --Finger size--
 steps: 21
 interval: 12.76
 min size: 12.7
 max size: 268
 average size: 50

 max Dist: 234.795654
 
 --retina--
 max Dist : 642
 
 
 --ipad2 retina--
 min size: 4.699997
 max size: 37.629990
 max Dist: 830.060242
 */