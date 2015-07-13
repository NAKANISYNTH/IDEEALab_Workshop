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
    bMoving.resize(TOUCH_NUM);
    
    
    ofBackground(255);
    
    gui.setDefaultWidth(500);
    gui.setDefaultHeight(50);
    gui.setup();
    gui.add(colorSlider.setup("color", ofColor(100,100), ofColor(0,0), ofColor(255,255)));
    gui.add(lineSizeSlider.setup("LineSize", 100, 1, 500));
    gui.add(resampleNumSlider.setup("resampleNum", 15, 1, 30));
    gui.add(bgArphaSlider.setup("bgArpha", 10, 0, 255));
    
    mFbo.allocate(ofGetWidth(), ofGetHeight(),GL_RGBA);
    mFbo.begin();
    ofClear(255, 255, 255, 0);
    mFbo.end();
    
    bShowGui = true;
    
}

//--------------------------------------------------------------
void ofApp::update(){
    ofEnableAlphaBlending();
    mFbo.begin();
    
    ofSetColor(255, bgArphaSlider);
    ofRect(0, 0, ofGetWidth(), ofGetHeight());
    
    
    ofSetColor(colorSlider);
    for (int tId = 0; tId < TOUCH_NUM; tId++) {
        if (bTouching[tId]) {
            
            if (bMoving[tId]) {
                
                ofPolyline touchPolyForSmooth;
                touchPolyForSmooth.addVertex(touchedPos[tId]);
                touchPolyForSmooth.addVertex(preTouchedPos[tId]);
                ofPolyline resampledPoly = touchPolyForSmooth.getResampledBySpacing(resampleNumSlider);
                
                for (int i = 0; i < resampledPoly.size(); i++) {
                    ofEllipse(resampledPoly[i], lineSizeSlider, lineSizeSlider);
                }
                
            }
            
            preTouchedPos[tId] = touchedPos[tId];
            
        }
        
        
        for (int i = 0; i < mParticles.size(); i++) {
            mParticles[i]->update();
            mParticles[i]->draw();
        }
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
        bMoving[touch.id] = true;
        
        particle *p = new particle(ofVec2f(touch.x, touch.y));
        mParticles.push_back(p);
        if (mParticles.size() > MAX_PARTICLE_NUM) {
            mParticles.erase(mParticles.begin());
        }
        
    }
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    
    bTouching[touch.id] = false;
    bMoving[touch.id] = false;
    
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
//    bShowGui = !bShowGui;
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
