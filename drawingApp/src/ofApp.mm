#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetCircleResolution(100);
    ofEnableSmoothing();
    
    if (isiPad) {
        TOUCH_NUM = 10;
    }
    touchedPos.resize(TOUCH_NUM);
    preTouchedPos.resize(TOUCH_NUM);
    bTouching.resize(TOUCH_NUM);
    
    ofBackground(0);
    
    gui.setDefaultWidth(500);
    gui.setDefaultHeight(50);
    gui.setup();
    gui.add(colorSlider.setup("color", ofColor(100,100), ofColor(0,0), ofColor(255,255)));
    gui.add(lineSizeSlider.setup("LineSize", 100, 1, 500));
    
    mFbo.allocate(ofGetWidth(), ofGetHeight(),GL_RGBA);
    mFbo.begin();
    ofClear(255, 255, 255, 0);
    mFbo.end();
    
    bShowGui = true;
    
    gui.getPosition();
    gui.getHeight();
    gui.getWidth();
}

//--------------------------------------------------------------
void ofApp::update(){
    mFbo.begin();
    ofSetColor(colorSlider);
    for (int tId = 0; tId < TOUCH_NUM; tId++) {
        if (bTouching[tId]) {
            ofEllipse(touchedPos[tId], lineSizeSlider, lineSizeSlider);
//            ofLine(preTouchedPos[tId], touchedPos[tId]);
        }
        preTouchedPos[tId] = touchedPos[tId];
        
    }
    mFbo.end();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofSetColor(255);
    mFbo.draw(0, 0);
    
    if (bShowGui) {
        gui.draw();
    }
    
    ofSetColor(255);
    ofDrawBitmapString(ofToString(ofGetFrameRate()), 10, ofGetHeight()-20);
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    ofMouseEventArgs arg;
    arg.x = touch.x;
    arg.y = touch.y;
    if (!gui.mousePressed(arg)) {
        touchedPos[touch.id] = ofPoint(touch.x, touch.y);
        bTouching[touch.id] = true;
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    ofMouseEventArgs arg;
    arg.x = touch.x;
    arg.y = touch.y;
    
    if (!gui.mouseMoved(arg)) {
        touchedPos[touch.id] = ofPoint(touch.x, touch.y);
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    
    bTouching[touch.id] = false;
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    bShowGui = !bShowGui;
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::lostFocus(){

}

//--------------------------------------------------------------
void ofApp::gotFocus(){

}

//--------------------------------------------------------------
void ofApp::gotMemoryWarning(){

}

//--------------------------------------------------------------
void ofApp::deviceOrientationChanged(int newOrientation){

}
