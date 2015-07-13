#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "ofxGui.h"

#define FIN_NUM 5 //指の数

class ofApp : public ofxiOSApp {

public:
    void setup();
    void update();
    void draw();
    void exit();

    void touchDown(ofTouchEventArgs & touch);
    void touchMoved(ofTouchEventArgs & touch);
    void touchUp(ofTouchEventArgs & touch);
    void touchDoubleTap(ofTouchEventArgs & touch);
    void touchCancelled(ofTouchEventArgs & touch);

    void lostFocus();
    void gotFocus();
    void gotMemoryWarning();
    void deviceOrientationChanged(int newOrientation);
    
    ofPolyline touchedPoints[FIN_NUM];
    bool isTouching[FIN_NUM]; //今タッチしているかどうかを示すフラグ
    
    ofFbo mFbo; //画面の画像を保持するクラス
    
    ofxPanel gui; //guiの土台
    ofxColorSlider colorSlider; //色のスライダー　これ自体をofColorクラスの値として代入できる
    ofxIntSlider circleSizeSlider; //int型（整数値）のスライダー　これ自体をint型の値として代入できる
    
};


