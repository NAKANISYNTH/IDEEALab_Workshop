#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    ofSetVerticalSync(true);
    ofBackgroundHex(0xfdefc2);
    ofSetLogLevel(OF_LOG_NOTICE);
    
    box2d.init();
    box2d.setGravity(0, 10);
    box2d.createBounds();
    box2d.setFPS(60.0);
    box2d.registerGrabbing();
    
    gui = new ofxUICanvas();
    
    vector<string> names;
    names.push_back("CIRCLE");
    names.push_back("BOX");
    gui->setFont("TSTARPRO-Bold.otf");
    gui->setRetinaResolution();
    gui->addLabel("OFXUI TUTORIAL", OFX_UI_FONT_LARGE);
    gui->addRadio("MODE", names);
    gui->autoSizeToFitWidgets();
    ofAddListener(gui->newGUIEvent, this, &ofApp::guiEvent);
    gui->loadSettings("settings.xml");
    
    
    ofxAccelerometer.setup();
}

//--------------------------------------------------------------
void ofApp::update(){
    box2d.update();
    box2d.setGravity(ofxAccelerometer.getForce().x*50, -ofxAccelerometer.getForce().y*50);
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    
    for(int i=0; i<circles.size(); i++) {
        ofFill();
        ofSetHexColor(0xf6c738);
        circles[i].get()->draw();
    }
    
    for(int i=0; i<boxes.size(); i++) {
        ofFill();
        ofSetHexColor(0xBF2545);
        boxes[i].get()->draw();
    }
    
    // draw the ground
    box2d.drawGround();
    
    
    
    string info = "";
    info += "Total Bodies: "+ofToString(box2d.getBodyCount())+"\n";
    info += "Total Joints: "+ofToString(box2d.getJointCount())+"\n\n";
    info += "FPS: "+ofToString(ofGetFrameRate(), 1)+"\n";
    ofSetHexColor(0x444342);
    ofDrawBitmapString(info, 30, 30);
}


//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
    if (mode == CIRCLE_MODE) {
        float r = ofRandom(4, 20);
        circles.push_back(shared_ptr<ofxBox2dCircle>(new ofxBox2dCircle));
        circles.back().get()->setPhysics(3.0, 0.53, 0.1);
        circles.back().get()->setup(box2d.getWorld(), mouseX, mouseY, r);
    }
    else if (mode == BOX_MODE) {
        float w = ofRandom(4, 20);
        float h = ofRandom(4, 20);
        boxes.push_back(shared_ptr<ofxBox2dRect>(new ofxBox2dRect));
        boxes.back().get()->setPhysics(3.0, 0.53, 0.1);
        boxes.back().get()->setup(box2d.getWorld(), mouseX, mouseY, w, h);
    }
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}


void ofApp::guiEvent(ofxUIEventArgs &e){
    if (e.getName() == "CIRCLE") {
        mode = CIRCLE_MODE;
    }
    else if (e.getName() == "BOX") {
        mode = BOX_MODE;
    }
}