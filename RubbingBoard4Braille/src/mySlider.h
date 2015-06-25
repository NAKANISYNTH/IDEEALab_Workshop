
#pragma once
#include "ofMain.h"

class mySlider{
    
public:
    mySlider(float val, float min, float max, int x = 0, int y = 0, int w = 100, int h = 20);
    ~mySlider();
    
    void draw();
    void setValue(float val);
    void setFillColor(ofColor c);
    void setLineColor(ofColor c);
    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    
    ofEvent<float> onValueChanged;
    
    float operator=(float v);
    operator const float & ();
    
    int x0, y0, width, height, x1, y1;
private:
    
    float value, minValue, maxValue;
    bool isInputing;
    int touchId;
    ofRectangle rect;
    int touchX, touchY;
    
    ofColor fillColor = ofColor(150);
    ofColor lineColor = 0;
    
    float convertFreqToNote(float _freq);
    string scales[12] = {"A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"};
};