

#include "FingerTrace.h"

ofImage FingerTrace::img;
int FingerTrace::counter = 0;

void FingerTrace::setup(){
    ofSetCircleResolution(100);
    maxSize = 0;
    minSize = 100000;
    maxDist = 0;
    
    fillColor = ofColor(255);
    
    if (counter == 0) {
        img.loadImage("particle32a.png");
        img.setAnchorPercent(0.5, 0.5);
    }
    
}

//--------------------------------------------------------------
void FingerTrace::update(){
    
    if (isTouching && moveDist >= minDist) {
        if (isiPad) {
            resampledPoints = getResampledBySpacing(pTouchX2, pTouchY2, touchX, touchY, 10); //space size is 10 when use ofCircle
        }
        else{
            resampledPoints = getResampledBySpacing(pTouchX2, pTouchY2, touchX, touchY, 10);
        }
        pTouchX2 = touchX;
        pTouchY2 = touchY;
    }
    
}

//--------------------------------------------------------------
void FingerTrace::draw(){
    ofEnableBlendMode(OF_BLENDMODE_ADD);
    if (isTouching && moveDist >= minDist) {
        ofSetColor(fillColor);
        
        for (int j = 0; j < resampledPoints.size(); j++) {
//            if (isiPad) {
////                ofCircle(resampledPoints[j] , pressure * 10);
//                img.ofBaseDraws::draw(resampledPoints[j] , pressure * 40, pressure * 40);
//            }
//            else{
                float cut = ofMap(moveDist, 0, 100, 0, 9);
                if (cut > 9) {
                    cut = 9;
                }
//                ofCircle(resampledPoints[j], 20 + pressure -cut);
//                float size = (40 + pressure -cut) * 4;
                float size = (40) * pressure;
//            cout << pressure <<endl;
                img.ofBaseDraws::draw(resampledPoints[j] , size, size);
//            }
        }
        
//        moveDist = 0;
    }
}

//--------------------------------------------------------------
void FingerTrace::exit(){
    
}

void FingerTrace::setFillColor(ofColor c){
    fillColor = c;
}

//--------------------------------------------------------------
void FingerTrace::touchDown(ofTouchEventArgs & touch){
    isTouching = true;
    touchX = pTouchX = pTouchX2 = touch.x;
    touchY = pTouchY = pTouchY2 = touch.y;
    resampledPoints.clear();
    timeStamp = ofGetElapsedTimeMillis();
}

//--------------------------------------------------------------
void FingerTrace::touchMoved(ofTouchEventArgs & touch){
    pressure = touch.pressure;
    touchX = touch.x;
    touchY = touch.y;
    if (ofGetElapsedTimeMillis() - timeStamp > 0) {
        moveDist = ofDist(pTouchX, pTouchY, touchX, touchY);
        timeStamp = ofGetElapsedTimeMillis();
//        cout << " dist : "  << moveDist << endl;
    }
    
    pTouchX = touchX;
    pTouchY = touchY;
    
//    if (touch.id == 0) {
//        float size = touch.pressure;
//    
//        if (size < minSize) {
//            minSize = size;
//        }
//        else if (size > maxSize) {
//            maxSize = size;
//        }
//    
//        if (moveDist > maxDist) {
//            maxDist = moveDist;
//        }
//        printf("min size: %f\n", minSize);
//        printf("max size: %f\n", maxSize);
//        printf("max Dist: %f\n", maxDist);
//    
//        sumSize += size;
//        count++;
//        printf("average size: %f\n", sumSize/(float)count);
//    
//    
//        if (sizeArray.size() == 0) {
//            sizeArray.push_back(size);
//        }
//        else{
//            for (int i=0; i < sizeArray.size(); i++) {
//                if (size == sizeArray[i]) {
//                    break;
//                }
//                if (i == sizeArray.size()-1) {
//                    sizeArray.push_back(size);
//                    i = sizeArray.size();
//                    printf("------sizearray------\n");
//                    for (int i=0; i < sizeArray.size(); i++) {
//                        printf("sizeArray %d: %f\n", i, sizeArray[i]);
//                    }
//                }
//            }
//        }
//    }
}

//--------------------------------------------------------------
void FingerTrace::touchUp(ofTouchEventArgs & touch){
    isTouching = false;
}

//--------------------------------------------------------------
void FingerTrace::touchDoubleTap(ofTouchEventArgs & touch){
    
}

//--------------------------------------------------------------
void FingerTrace::touchCancelled(ofTouchEventArgs & touch){
    
}

ofPolyline FingerTrace::getResampledBySpacing(int x0, int y0, int x1, int y1, int space){
    ofPolyline p;
    p.addVertex(x0, y0);
    p.addVertex(x1, y1);
    return p.getResampledBySpacing(space);
}

