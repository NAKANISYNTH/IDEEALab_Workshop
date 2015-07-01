
#pragma once

#include "ofMain.h"

class particle {

public:
    
    particle(ofVec2f pos);
    void setup();
    void update();
    void draw();
    
    
private:
    
    ofVec2f positon;
    ofVec2f velocity;
    float radius;
    
};