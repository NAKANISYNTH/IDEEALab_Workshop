
#pragma once

#include "ofMain.h"
#include "iOSDevice.h"

#include "ofxPd.h"

class FingerTrace{
    
public:
    void setup();
    void update();
    void draw();
    void exit();
    
    void setFillColor(ofColor c);
    
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);
    
    ofPolyline getResampledBySpacing(int x0, int y0, int x1, int y1, int space);
    
    float minSize, maxSize, sumSize, count;
    vector<float> sizeArray;
    float maxDist;
    
    float speed;
    float moveDist;
    float minDist = 0;
    bool isTouching;
    float pressure;
    ofPolyline resampledPoints;
    
    int touchX, touchY, pTouchX, pTouchY; //for measure distance
private:
    
    int pTouchX2, pTouchY2; //for draw connected lines
//    int alpha;
    
    ofColor fillColor;
    
    int timeStamp; //measure distance for a certain period of time
    
    static ofImage img;
    static int counter;
};
