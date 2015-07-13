
#pragma once
#include "ofMain.h"

class Ball{
    
public:
    
    Ball(int x, int y);
    ~Ball();
    
    void setup();
    void update();
    virtual void draw();
    
    
protected:
    
    ofPoint position;
    ofVec2f speed;
    
};