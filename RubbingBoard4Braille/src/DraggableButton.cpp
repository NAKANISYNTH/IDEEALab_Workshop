//
//  DraggableButton.cpp
//  iosSongLooper
//
//  Created by kyosuke on 1/20/15.
//
//

#include "DraggableButton.h"

ofEvent<draggableButtonArgs> DraggableButton::onButtonTouchDown;
ofEvent<draggableButtonArgs> DraggableButton::onButtonTouchMoved;
ofEvent<draggableButtonArgs> DraggableButton::onButtonTouchUp;

DraggableButton::DraggableButton(int id, int x, int y, int w, int h ){
    buttonId = id;
    x0 = x;
    y0 = y;
    width = w;
    height = h;
    x1 = x0 + width;
    y1 = y0 + height;
    
    rect.set(x0, y0, width, height);
    
    //    bTouching = false;
    
    ofAddListener(ofEvents().touchDown, this, &DraggableButton::touchDown);
    ofAddListener(ofEvents().touchMoved, this, &DraggableButton::touchMoved);
    ofAddListener(ofEvents().touchUp, this, &DraggableButton::touchUp);
}

DraggableButton::~DraggableButton(){
    ofRemoveListener(ofEvents().touchDown, this, &DraggableButton::touchDown);
    ofRemoveListener(ofEvents().touchMoved, this, &DraggableButton::touchMoved);
    ofRemoveListener(ofEvents().touchUp, this, &DraggableButton::touchUp);
}

void DraggableButton::draw(){
    ofFill();
    ofSetColor(fillColor);
    ofRect(rect);
    
    //    if (bTouching == true) {
    ofNoFill();
    ofSetLineWidth(2);
    ofSetColor(lineColor);
    ofRect(rect);
    //        cout << "line "<<endl;
    //    }
}

ofPoint DraggableButton::getPosition(){
    return ofPoint(x0, y0);
}

ofColor DraggableButton::getColor(){
    return fillColor;
}

void DraggableButton::setFillColor(ofColor c){
    fillColor = c;
}

void DraggableButton::setLineColor(ofColor c){
    lineColor = c;
}

void DraggableButton::touchDown(ofTouchEventArgs &touch){
    if (rect.inside(touch.x, touch.y)) {
        bTouching[touch.id] = true;
        //        touchId = touch.id;
        
        draggableButtonArgs args;
        args.buttonID = buttonId;
        args.touch = touch;
        ofNotifyEvent(onButtonTouchDown, args);
    }
}

void DraggableButton::touchMoved(ofTouchEventArgs &touch){
    if (rect.inside(touch.x, touch.y)) {
        
        if (bTouching[touch.id]) {
            draggableButtonArgs args;
            args.buttonID = buttonId;
            args.touch = touch;
            ofNotifyEvent(onButtonTouchMoved, args);
        }
        else{
            touchDown(touch);
        }
        
    }
    else{
        bTouching[touch.id] = false;
    }
}

void DraggableButton::touchUp(ofTouchEventArgs &touch){
    if (bTouching && bTouching[touch.id]) {
        draggableButtonArgs args;
        args.buttonID = buttonId;
        args.touch = touch;
        ofNotifyEvent(onButtonTouchUp, args);
        bTouching[touch.id] = false;
    }
}