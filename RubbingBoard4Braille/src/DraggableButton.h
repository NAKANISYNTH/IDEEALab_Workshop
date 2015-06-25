
#pragma once

#include "ofMain.h"

class draggableButtonArgs{
public:
    int buttonID;
    ofTouchEventArgs touch;
};

class DraggableButton{
    
public:
    
    DraggableButton(int id, int x = 0, int y = 0, int w = 50, int h = 50);
    ~DraggableButton();
    
    void draw();
    void setFillColor(ofColor c);
    void setLineColor(ofColor c);
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    
    ofPoint getPosition();
    ofColor getColor();
    static ofEvent<draggableButtonArgs> onButtonTouchDown;
    static ofEvent<draggableButtonArgs> onButtonTouchMoved;
    static ofEvent<draggableButtonArgs> onButtonTouchUp;
    
    int x0, y0, width, height, x1, y1;
    
    bool bTouching[10]; //
private:
    
    int buttonId;
    bool value;
    ofRectangle rect;
    
    ofColor fillColor = ofColor(0);
    ofColor lineColor = 100;
    
};