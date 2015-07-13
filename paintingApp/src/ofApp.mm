#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){	
    ofBackground(0); //背景を黒にする
    
    mFbo.allocate(ofGetWidth(), ofGetHeight()); //保持する画像の大きさを設定
    
    //guiの設定
    gui.setDefaultWidth(500);
    gui.setDefaultHeight(100);
    gui.setup("setting");
    gui.add(colorSlider.setup("color", ofColor(200,200,100),ofColor(0,0), ofColor(255,255)));
    gui.add(circleSizeSlider.setup("circleSize", 10, 1, 200));
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    mFbo.begin();
    
    ofSetColor(colorSlider);
    for (int finID = 0; finID < FIN_NUM; finID++) { //指の数だけループ
        
        if (isTouching[finID]) { //指が動いた時に円を描画する
            
            //2点以上保存されているとき描画
            if (touchedPoints[finID].size() >= 2) {
                ofPolyline resampledLine = touchedPoints[finID].getResampledBySpacing(1);//点と点の間に1間隔で点を追加する
                
                //補完して得られた座標全てに円を描く
                for (int i = 0; i < resampledLine.size(); i++) {
                    ofEllipse(resampledLine[i], circleSizeSlider, circleSizeSlider);
                }
                
                //最後の点だけ残して他は消す
                ofPoint lastP = ofPoint(resampledLine[resampledLine.size()-1].x, resampledLine[resampledLine.size()-1].y);
                touchedPoints[finID].clear();
                touchedPoints[finID].addVertex(lastP);
                
            }
            
        }
        
    }
    
    mFbo.end();
    
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    ofSetColor(255);
    mFbo.draw(0, 0);
    
    ofDrawBitmapString(ofToString(ofGetFrameRate()), 10, 500); //フレームレートをテキストで描画　ofToStringでofGetFrameRateで取得したフレームレートの値をstring型に変換している
    
    gui.draw();
    
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){ //タッチした時に呼ばれる
    ofMouseEventArgs args;
    args.x = touch.x;
    args.y = touch.y;
    if (gui.mousePressed(args) == false) {
        touchedPoints[touch.id].addVertex(touch.x, touch.y);
        isTouching[touch.id] = true;
    }
    
}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){ //タッチして指を動かした時に呼ばれる
    ofMouseEventArgs args;
    args.x = touch.x;
    args.y = touch.y;
    if (gui.mouseDragged(args) == false) {
        touchedPoints[touch.id].addVertex(touch.x, touch.y);
    }
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){ //タッチして指を画面からはなした時に呼ばれる
    isTouching[touch.id] = false;
    touchedPoints[touch.id].clear(); //指をはなしたら全部消す
}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){ //ダブルタッチした時に呼ばれる

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
