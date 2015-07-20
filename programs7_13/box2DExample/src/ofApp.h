
/*
 ofxBox2dとofxUIを使ったiOSアプリのサンプル。
 
 - 機能 -
 ・ドラッグしたところからオブジェクトが生成される
 ・端末の向きに合わせて重力が変わる
 ・GUIで生成するオブジェクトを切り替える
 
 */
#pragma once

#include "ofMain.h"
#include "ofxiOS.h"
#include "ofxiOSExtras.h"

#include "ofxBox2d.h"
#include "ofxUI.h"

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
    
    ofxBox2d                            box2d;			  //	box2dの世界
    vector    <shared_ptr<ofxBox2dCircle> >	circles;		  // ofxBox2dCircleクラスのベクター配列
    vector	  <shared_ptr<ofxBox2dRect> >	boxes;			  // ofxBox2dRectクラスのベクター配列
    //shared_ptrはスマートポインタの一種　詳しくはhttp://d.hatena.ne.jp/haru-s/20081231/1230716657
    
    
    ofxUICanvas *gui; //ofxUIのベースになるオブジェクト
    void guiEvent(ofxUIEventArgs &e); //ofxUIのイベントを処理する関数
    
    int mode; //0のときはサークル、1のときはボックスを追加するため
    static const int CIRCLE_MODE = 0;
    static const int BOX_MODE = 1;
};


