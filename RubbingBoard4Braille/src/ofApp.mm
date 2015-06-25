#include "ofApp.h"
#include "FingerTrace.h"


//--------------------------------------------------------------
void ofApp::setup(){
    setOrientationLandscape();
    
    if (isiPad) {
        FINGER_NUM = 10;
    }
    else{
        FINGER_NUM = 5;
    }
    timeStamp.resize(FINGER_NUM);
    note.resize(FINGER_NUM);
    freq.resize(FINGER_NUM);
    volume.resize(FINGER_NUM);
    
    
    //***************gui
    ofAddListener(DraggableButton::onButtonTouchDown, this, &ofApp::onButtonTouchDown);
    ofAddListener(DraggableButton::onButtonTouchMoved, this, &ofApp::onButtonTouchMoved);
    ofAddListener(DraggableButton::onButtonTouchUp, this, &ofApp::onButtonTouchUp);
    for (int i = 0; i < barNum; i++) {
        brailleBar[i] = new DraggableButton(0, 100+200*(i%3), 100+200*i, 1000, 100);
        brailleBar[i]->setFillColor(255);
    }
    
    
    delayTime.addListener(this, &ofApp::onChangedDelayTime);
    delayDecay.addListener(this, &ofApp::onChangedDelayDecay);
    ofxGuiSetDefaultWidth(ofGetWidth()*0.8);
    ofxGuiSetDefaultHeight(100);
    gui.setup();
    //white:229,206,219,57
    gui.add(drawColor.setup("color",ofColor(110,120,140,100),ofColor(0,0),ofColor(255,255)));
    gui.add(minThreshold.setup("Min Gyro Threshold", 0.26, 0, 1));
    gui.add(maxThreshold.setup("Max Gyro Threshold", 2.12, 0.1, 3));
    gui.add(maxFeedback.setup("Feedback", 1.06, 1, 1.1));
    
    gui.add(delayTime.setup("Time of Delay", 258, 0.0001, 50));
    gui.add(delayDecay.setup("Decay of Delay", 1410, 1, 3000));
    
    
    ofxiOSAlerts.addListener(this);
    // the number if libpd ticks per buffer,
    // used to compute the audio buffer len: tpb * blocksize (always 64)
    int ticksPerBuffer = 8; // 8 * 64 = buffer len of 512
    mLibPd.setup(2, 0, 44100, ticksPerBuffer);
    ofSoundStreamSetup(2, 0, this, 44100, ofxPd::blockSize()*ticksPerBuffer, 3);
    mLibPd.play();
    mLibPd.setDelayDecay(delayDecay);
    mLibPd.setDelayTime(delayTime);
    
    ofBackground(bgColor);
    
    
    
    //fingers
    mFingerTraces.resize(FINGER_NUM);
    int x = 20;
    int y = 20;
    int w = 400;
    int h = 30;
    for (int i = 0; i < mFingerTraces.size(); i++) {
        mFingerTraces[i] = new FingerTrace();
        mFingerTraces[i]->setup();
        mFingerTraces[i]->minDist = minDist;
        mFingerTraces[i]->setFillColor(drawColor);
        timeStamp[i] = ofGetElapsedTimeMillis();
        
        mySlider *s = new mySlider(0, minFreq, maxFreq, x, y+=h+10, w, h);
        s->setLineColor(ofColor(0,255,0));
        mMySliderVec.push_back(s);
    }
    
    
    
    //motion
    coreMotion.setupMagnetometer();
    coreMotion.setupGyroscope();
    coreMotion.setupAccelerometer();
    coreMotion.setupAttitude(CMAttitudeReferenceFrameXMagneticNorthZVertical);
    bShowGui = true;
    
    beginRoll = coreMotion.getRoll();
    
}

//--------------------------------------------------------------
void ofApp::update(){
    if(isiOS8){ //多分一回描画関係の関数を通らないとダメなんでしょう
        if(ofxiOSGetGLView().frame.origin.x != 0
           || ofxiOSGetGLView().frame.size.width != [[UIScreen mainScreen] bounds].size.width){
            
            ofxiOSGetGLView().frame = CGRectMake(0,0,[[UIScreen mainScreen] bounds].size.width,[[UIScreen mainScreen] bounds].size.height);
        }
        isiOS8 = false;
    }
    
    
    
    //gyro computation for feedback
    coreMotion.update();
    g = coreMotion.getGyroscopeData();
    float gSum = abs(g.x) + abs(g.y) + abs(g.z);
    if (gSum < 1.5) {
        float feedbackRate = ofMap(gSum, minThreshold, maxThreshold, 0, maxFeedback);
        if (feedbackRate < 0) {
            feedbackRate = 0;
        }
        else if(feedbackRate > maxFeedback){
            feedbackRate = maxFeedback;
        }
        mLibPd.setDelayFeedback(feedbackRate);
    }
    preGyroSum = gSum;
    
    
    
    for (int i = 0; i < FINGER_NUM; i++) {
        //sound off
        if (ofGetElapsedTimeMillis()-timeStamp[i] > 50) {
            mLibPd.setId(i);
            mLibPd.setVolume(0);
            volume[i] = 0;
            note[i] = 0;
            freq[i] = 0;
            timeStamp[i] = ofGetElapsedTimeMillis();
        }
    }
    
    
    //rotation
    if (abs(ofRadToDeg(coreMotion.getRoll()-beginRoll)) > 170) {
        if ( !bSwinged) {
            bShowGui = !bShowGui;
            bSwinged = true;
        }
    }
    else{
        bSwinged = false;
    }
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    for (int i = 0; i < barNum; i++) {
        brailleBar[i]->draw();
    }
    
    
    for (int i = 0; i < mFingerTraces.size(); i++) {
        mFingerTraces[i]->setFillColor(drawColor);
        mFingerTraces[i]->update();
        mFingerTraces[i]->draw();
        
    }
    
    
    //framerate text
    ofSetColor(255);
    ofDrawBitmapString(ofToString(ofGetFrameRate()), 10, ofGetHeight()/2);
    
    bShowGui = false; //回転で表示できるやつ今は消す
    if (bShowGui) {
        
        ofEnableAlphaBlending();
        for (int i = 0; i < mMySliderVec.size(); i++) {
            if (mFingerTraces[i]->isTouching) {
                
                //sliders
                *mMySliderVec[i] = freq[i];
                mMySliderVec[i]->draw();
                
                //lines from finger to slider
                ofNoFill();
                ofSetColor(ofColor::fromHsb(i*255/(float)FINGER_NUM, 255, 150));
                ofCircle(mFingerTraces[i]->touchX, mFingerTraces[i]->touchY, 100);
                ofLine(mMySliderVec[i]->x1, mMySliderVec[i]->y1-mMySliderVec[i]->height/2, mFingerTraces[i]->touchX, mFingerTraces[i]->touchY);
                
            }
        }
        
        
        //sensor parameter
        ofFill();
        int x = ofGetWidth()/2;
        int y = ofGetHeight()*0.8;
        int maxX = 500;
        //roll　pitch yaw
        ofSetColor(255,0,0);
        ofDrawBitmapString("quat", x, y+=10);
        ofRect(x, y+=10, coreMotion.getRoll()*maxX, 10);
        ofRect(x, y+=10, coreMotion.getPitch()*maxX, 10);
        ofRect(x, y+=10, coreMotion.getYaw()*maxX, 10);
        
        ofDrawBitmapString(ofToString(ofRadToDeg(coreMotion.getRoll()-beginRoll) + PI), 300, y);
        
        //acc
        ofSetColor(255,255,0);
        ofVec3f a = coreMotion.getAccelerometerData();
        ofDrawBitmapString("acc", x, y+=20);
        for (int i = 0; i < 3; i++) {
            ofRect(x, y+=10, a[i]*maxX, 10);
        }
        
        //gyro
        ofSetColor(0,255,0);
        y+=10;
        ofVec3f g = coreMotion.getGyroscopeData();
        for (int i = 0; i < 3; i++) {
            ofRect(x, y, g[i]*maxX, 10);
            ofDrawBitmapString(ofToString(g[i]), x+g[i]*maxX, y);
            y += 10;
        }
        ofDrawBitmapString("Gyro sum: "+ofToString(preGyroSum), x, y);
        
//        gui.draw();
        
        
    }
}

//--------------------------------------------------------------
void ofApp::exit(){
    mLibPd.exit();
    mFingerTraces.clear();
}

void ofApp::onButtonTouchDown(draggableButtonArgs &btnTouch){
    int touchID = btnTouch.touch.id;
    if (touchID < mFingerTraces.size()) {
        mFingerTraces[touchID]->touchDown(btnTouch.touch);
    }
}

void ofApp::onButtonTouchMoved(draggableButtonArgs &btnTouch){
    int touchID = btnTouch.touch.id;
    if (btnTouch.touch.id < mFingerTraces.size()) {
        
        
        mFingerTraces[touchID]->touchMoved(btnTouch.touch);
        
        //set id
        mLibPd.setId(touchID);
        
        float dist = mFingerTraces[touchID]->moveDist;
        if (dist >= minDist) {
            
            //set pitch
            int n;
            float f;
            if (isiPad) {
                n = ofMap(dist, minDist, maxDist, minNote, maxNote); //dist -> note
                f = ofMap(dist, minDist, maxDist, minFreq, maxFreq); //dist -> freq
            }
            else{
                f = ofMap(dist, minDist, maxDist, minFreq, maxFreq); //dist -> freq
            }
            
            if (n != note[touchID]) {
                //                note[touchID] = n;
                //                mLibPd.setNote(n);
                
                freq[touchID] = f;
                mLibPd.setFreq(f);
            }
            
            
            // volume
            float v;
            float maxV = 1;
            if (isiPad) {
                v = ofMap(mFingerTraces[touchID]->pressure, 4.7, 19, 0.05, maxV); // pressure
                
                if (v > maxV) {
                    v = maxV;
                }
            }
            else{
                v = ofMap(mFingerTraces[touchID]->pressure, 12.7, 100, 0.01, maxV);
                if (v > maxV) {
                    v = maxV;
                }
            }
            if (v != volume[touchID]) {
                volume[touchID] = v;
                mLibPd.setVolume(v);
            }
        }
        
    }
    timeStamp[touchID] = ofGetElapsedTimeMillis();
}

void ofApp::onButtonTouchUp(draggableButtonArgs &btnTouch){
    int touchID = btnTouch.touch.id;
    if (touchID < mFingerTraces.size()) {
        mFingerTraces[touchID]->touchUp(btnTouch.touch);
        mLibPd.setId(touchID);
        mLibPd.setVolume(0);
    }
}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){
//    if (touch.id < mFingerTraces.size()) {
//        mFingerTraces[touch.id]->touchDown(touch);
//    }
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
//    if (touch.id < mFingerTraces.size()) {
//        mFingerTraces[touch.id]->touchMoved(touch);
//        
//        //set id
//        mLibPd.setId(touch.id);
//        
//        float dist = mFingerTraces[touch.id]->moveDist;
//        if (dist >= minDist) {
//            
//            //set pitch
//            int n;
//            float f;
//            if (isiPad) {
//                n = ofMap(dist, minDist, maxDist, minNote, maxNote); //dist -> note
//                f = ofMap(dist, minDist, maxDist, minFreq, maxFreq); //dist -> freq
//            }
//            else{
//                f = ofMap(dist, minDist, maxDist, minFreq, maxFreq); //dist -> freq
//            }
//            
//            if (n != note[touch.id]) {
////                note[touch.id] = n;
////                mLibPd.setNote(n);
//                
//                freq[touch.id] = f;
//                mLibPd.setFreq(f);
//            }
//        
//        
//        // volume
//            float v;
//            float maxV = 1;
//            if (isiPad) {
//                v = ofMap(mFingerTraces[touch.id]->pressure, 4.7, 19, 0.05, maxV); // pressure
//
//                if (v > maxV) {
//                    v = maxV;
//                }
//            }
//            else{
//                v = ofMap(mFingerTraces[touch.id]->pressure, 12.7, 100, 0.01, maxV);
//                if (v > maxV) {
//                    v = maxV;
//                }
//            }
//            if (v != volume[touch.id]) {
//                volume[touch.id] = v;
//                mLibPd.setVolume(v);
//            }
//        }
//        
//    }
//    timeStamp[touch.id] = ofGetElapsedTimeMillis();
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){
//    if (touch.id < mFingerTraces.size()) {
//        mFingerTraces[touch.id]->touchUp(touch);
//        mLibPd.setId(touch.id);
//        mLibPd.setVolume(0);
//    }
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void ofApp::touchCancelled(ofTouchEventArgs & touch){
    
}

void ofApp::onChangedDelayDecay(float &f){
    mLibPd.setDelayDecay(f);
}

void ofApp::onChangedDelayTime(float &f){
    mLibPd.setDelayTime(f);
}

void ofApp::audioReceived(float * input, int bufferSize, int nChannels) {
    
}

void ofApp::audioRequested(float * output, int bufferSize, int nChannels) {
    mLibPd.audioRequested(output, bufferSize, nChannels);
}

void ofApp::setOrientationLandscape(){
    NSString *reqSysVer = @"8.0";
    NSString *currSysVer = [[UIDevice currentDevice] systemVersion];
    if ([currSysVer compare:reqSysVer options:NSNumericSearch] == NSOrderedDescending) {
        isiOS8 = true;
        printf("size: %d, %d\n", screenWidth, screenHeight);
        NSLog(@"device ver. is %@ >= %@ ",currSysVer, reqSysVer);
        screenWidth = ofGetHeight();
        screenHeight = ofGetWidth();
    }
    else{
        isiOS8 = false;
        printf("size: %d, %d\n", screenWidth, screenHeight);
        NSLog(@"device ver. is %@ < %@ ",currSysVer, reqSysVer);
        if (ofGetHeight() > ofGetWidth()) {
            screenWidth = ofGetHeight();
            screenHeight = ofGetWidth();
        }
        else{
            screenWidth = ofGetWidth();
            screenHeight = ofGetHeight();
        }
    }
    
    ofSetOrientation(ofxiOS_ORIENTATION_LANDSCAPE_LEFT);
}
