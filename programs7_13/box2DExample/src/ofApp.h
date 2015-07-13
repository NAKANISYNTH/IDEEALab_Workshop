#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "ofxBox2d.h"
#include "ofxUI.h"

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
    
    ofxBox2d                            box2d;			  //	the box2d world
    vector    <shared_ptr<ofxBox2dCircle> >	circles;		  //	default box2d circles
    vector	  <shared_ptr<ofxBox2dRect> >	boxes;			  //	defalut box2d rects
    
    
    ofxUICanvas *gui;
    void guiEvent(ofxUIEventArgs &e);
    int mode;
    static const int CIRCLE_MODE = 0;
    static const int BOX_MODE = 1;
};


