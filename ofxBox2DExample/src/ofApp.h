#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"
#include "ofxBox2d.h"
#include "ofxUI.h"

#define MODE_CIRCLE 0
#define MODE_RECTANGLE 1
#define MODE_CATCH 2
#define MODE_LINE 3

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
    
    
    ofxBox2d                            box2d;
    vector    <shared_ptr<ofxBox2dCircle> >	circles;
    vector	  <shared_ptr<ofxBox2dRect> >	boxes;
    vector <ofPolyline>                 lines;
    vector <shared_ptr<ofxBox2dEdge> >       edges;
    uint8_t mode;
    
    
    ofxUICanvas *gui;
    void guiEvent(ofxUIEventArgs &e);
    float density = 3;
    float bounce = 0.53;
    float friction = 0.1;
    
    float gravity = 50;
    bool isInputingGUI;
    
    bool bShowGui = true;

};


