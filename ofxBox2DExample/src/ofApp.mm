#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    
//    ofSetVerticalSync(true);
    ofBackgroundHex(0xfdefc2);
    ofSetLogLevel(OF_LOG_NOTICE);
    
    box2d.init();
    box2d.setGravity(0, 10);
//    box2d.createBounds();
    box2d.createGround();
    box2d.setFPS(60.0);
    box2d.registerGrabbing();
    
    
    //----gui
    vector<string> names;
    names.push_back("CIRCLE");
    names.push_back("RECTANGLE");
    names.push_back("CATCH");
    names.push_back("LINE");
    
    gui = new ofxUICanvas();
    gui->setRetinaResolution();
    gui->setPosition(10, 100);
    gui->setModal(true);
    gui->setFont("TSTARPRO-Medium.otf");
    gui->addLabel("MODE SWITCH", OFX_UI_FONT_LARGE);
//    gui->addSlider("BACKGROUND",0.0,255.0,100.0);
    
    gui->addRadio("MODE SWITCH", names, OFX_UI_ORIENTATION_HORIZONTAL);
    gui->addButton("CLEAR_LINE", false);
    
    gui->addSlider("DENSITY", 0, 10, 3);
    gui->addSlider("BOUNCE", 0, 10, 0.53);
    gui->addSlider("FRICTION", 0, 10, 0.1);
    
    gui->autoSizeToFitWidgets();
    ofAddListener(gui->newGUIEvent, this, &ofApp::guiEvent);
//    gui->loadSettings("settings.xml");
}

//--------------------------------------------------------------
void ofApp::update(){
    box2d.update();
    
    ofRemove(boxes, ofxBox2dBaseShape::shouldRemoveOffScreen);
    ofRemove(circles, ofxBox2dBaseShape::shouldRemoveOffScreen);
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
    
    ofSetColor(0,50);
    ofNoFill();
    for (int i=0; i<lines.size(); i++) {
        lines[i].draw();
    }
    ofSetColor(10);
    for (int i=0; i<edges.size(); i++) {
        edges[i].get()->draw();
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
    if (gui->isHit(touch.x, touch.y)) {
        isInputingGUI = true;
    }
    
    
    if (!isInputingGUI) {
        
        if (mode == MODE_LINE){
            lines.push_back(ofPolyline());
            lines.back().addVertex(touch.x, touch.y);
        }
        
    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
    if (!isInputingGUI) {
        
        if (mode == MODE_CIRCLE) {
            float r = ofRandom(10, 50);
            circles.push_back(shared_ptr<ofxBox2dCircle>(new ofxBox2dCircle));
            circles.back().get()->setPhysics(density, bounce, friction);
            circles.back().get()->setup(box2d.getWorld(), mouseX, mouseY, r);
        }
        else if (mode == MODE_RECTANGLE) {
            int w = ofRandom(10, 50);
            int h = ofRandom(10, 50);
            boxes.push_back(shared_ptr<ofxBox2dRect>(new ofxBox2dRect));
            boxes.back().get()->setPhysics(density, bounce, friction);
            boxes.back().get()->setup(box2d.getWorld(), mouseX, mouseY, w, h);
        }
        else if (mode == MODE_CATCH) {
            //
        }
        else if (mode == MODE_LINE){
            lines.back().addVertex(touch.x, touch.y);
        }
    
    }
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
    if (mode == MODE_LINE){
        shared_ptr <ofxBox2dEdge> edge = shared_ptr<ofxBox2dEdge>(new ofxBox2dEdge);
        lines.back().simplify();
        
        for (int i=0; i<lines.back().size(); i++) {
            edge.get()->addVertex(lines.back()[i]);
        }
        
        //poly.setPhysics(1, .2, 1);  // uncomment this to see it fall!
        edge.get()->create(box2d.getWorld());
        edges.push_back(edge);
        
    }
    
    isInputingGUI = false;
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}



void ofApp::guiEvent(ofxUIEventArgs &e)
{
    if(e.getName() == "CIRCLE")
    {
//        ofxUISlider *slider = e.getSlider();
//        ofBackground(slider->getScaledValue());
        mode = MODE_CIRCLE;
    }
    else if(e.getName() == "RECTANGLE")
    {
//        ofxUIToggle *toggle = (ofxUIToggle *) e.widget;
        mode = MODE_RECTANGLE;
        
    }
    else if(e.getName() == "CATCH")
    {
        mode = MODE_CATCH;
    }
    else if(e.getName() == "LINE")
    {
        mode = MODE_LINE;
    }
    else if(e.getName() == "CLEAR_LINE")
    {
        lines.clear();
        edges.clear();
    }
    else if(e.getName() == "DENSITY")
    {
        ofxUISlider *slider = (ofxUISlider *) e.widget;
        density = slider->getScaledValue();
    }
    else if(e.getName() == "BOUNCE")
    {
        ofxUISlider *slider = (ofxUISlider *) e.widget;
        bounce = slider->getScaledValue();
    }
    else if(e.getName() == "FRICTION")
    {
        ofxUISlider *slider = (ofxUISlider *) e.widget;
        friction = slider->getScaledValue();
    }
}
