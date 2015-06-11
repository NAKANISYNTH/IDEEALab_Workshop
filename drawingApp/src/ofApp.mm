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
    
}

//--------------------------------------------------------------
void ofApp::update(){
    mFbo.begin();
    ofSetColor(colorSlider);
    for (int i = 0; i < touchedPos.size(); i++) {
        ofEllipse(touchedPos[i], lineSizeSlider, lineSizeSlider);
    }
    touchedPos.clear(); //描画したら初期化
    mFbo.end();
}

//--------------------------------------------------------------
void ofApp::draw(){
    ofSetColor(255);
    mFbo.draw(0, 0);
    
    gui.draw();
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
    touchedPos.push_back(ofPoint(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    touchedPos.push_back(ofPoint(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

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
