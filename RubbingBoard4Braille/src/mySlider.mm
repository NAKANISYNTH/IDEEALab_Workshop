//
//  mySlider.cpp
//  iosSongLooper
//
//  Created by kyosuke on 1/14/15.
//
//

#include "mySlider.h"

mySlider::mySlider(float val, float min, float max, int x, int y, int w, int h){
    
    x0 = x;
    y0 = y;
    width = w;
    height = h;
    x1 = x0 + width;
    y1 = y0 + height;
    value = val;
    minValue = min;
    maxValue = max;
    
    rect.set(x0, y0, width, height);
}

mySlider::~mySlider(){
    
}

void mySlider::draw(){
    ofFill();
    ofSetColor(fillColor);
    ofRect(rect);
    
    
    ofFill();
    ofSetColor(lineColor);
    float lineX = ofMap(value, minValue, maxValue, x0, x1);
    int w = 10;
    ofRect(lineX-w/2, y0, w, height);
    
    ofNoFill();
    ofSetColor(255);
    ofLine(lineX, y0, lineX, y1);
    
    //freq text
    string s = "";
    int note = convertFreqToNote(value);
    ofDrawBitmapString(ofToString(note), x1+5, y0+height/2);
    //scale text
    float dec = 1 - (note/12.0f - int(note/12));
    ofSetColor(255*dec);
    int scaleIndex = note/12.0f;
    if (scaleIndex > 11 || scaleIndex < 0) scaleIndex = 0;
    ofDrawBitmapString(scales[scaleIndex], x1+50, y0+height/2);
}

void mySlider::setValue(float val){
    value = val;
}

void mySlider::setFillColor(ofColor c){
    fillColor = c;
}

void mySlider::setLineColor(ofColor c){
    lineColor = c;
}

float mySlider::operator=(float v){
    value = v;
    return v;
}

mySlider::operator const float & (){
    return value;
}

float mySlider::convertFreqToNote(float _freq){
    float d = 69 + 12*log2(_freq/440.0f);
    return d;
}

void mySlider::touchDown(ofTouchEventArgs &touch){
    if (rect.inside(touch.x, touch.y)) {
        isInputing = true;
        touchId = touch.id;
        touchX = touch.x;
        touchY = touch.y;
    }
}

void mySlider::touchMoved(ofTouchEventArgs &touch){
    if (isInputing && touchId == touch.id) {
       
        touchX = touch.x;
        if (touchX < x0) {
            touchX = x0;
        }
        else if(touchX > x1){
            touchX = x1;
        }
        
        touchY = touch.y;
        if (touchY < y0) {
            touchY = y0;
        }
        else if(touchY > y1){
            touchY = y1;
        }
        
        int v = (int)ofMap(touchX, x0, x1, minValue, maxValue);
        if (value != v) {
            value = v;
            ofNotifyEvent(onValueChanged, value, this);
        }
    }
}

void mySlider::touchUp(ofTouchEventArgs &touch){
    if (isInputing && touchId == touch.id) {
        isInputing = false;
    }
}