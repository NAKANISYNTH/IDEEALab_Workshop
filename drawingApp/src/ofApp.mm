#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    
    ofBackground(0);
    
    gui.setDefaultWidth(500);
    gui.setDefaultHeight(100);
    gui.setup();
    gui.setName("settings");
    gui.add(colorSlider.setup("color", 255, 0, 255));
    gui.add(lineSizeSlider.setup("LineSize", 100, 1, 500));
    
    mFbo.allocate(ofGetWidth(), ofGetHeight(),GL_RGBA);
    mFbo.begin();
    ofClear(255, 255, 255, 0);
    mFbo.end();
    
    bShowGui = true;
    
}

//--------------------------------------------------------------
void ofApp::update(){
    mFbo.begin();
    ofSetColor(colorSlider);
    for (int tId = 0; tId < TOUCH_NUM; tId++) {
        if (bTouching[tId]) {
            ofEllipse(touchedPos[tId], lineSizeSlider, lineSizeSlider);
            ofLine(preTouchedPos[tId], touchedPos[tId]);
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
    touchedPos[touch.id] = ofPoint(touch.x, touch.y);
    bTouching[touch.id] = true;
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchedPos[touch.id] = ofPoint(touch.x, touch.y);
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
