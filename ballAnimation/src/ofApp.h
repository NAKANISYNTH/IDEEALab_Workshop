/*
 タッチしたところから複数のボールが出てきて飛んで行くだけのアプリ。
 クラスを作って継承する練習をした。
 
 */
#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "Ball.h" //Ballクラス読み込み
#include "Box.h" //Boxクラス

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
    
    vector<Ball *> balls; //Ballクラスのベクター配列
    vector<Box *> boxes; //Boxクラスのベクター配列
};


