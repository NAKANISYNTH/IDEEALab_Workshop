#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
}

//--------------------------------------------------------------
void ofApp::update(){
    
    //全てのBallのオブジェクトを更新
    for (int i = 0; i < balls.size(); i++) {
        balls[i]->update();
    }
    
    
    //全てのBoxのオブジェクトを更新
    for (int i = 0; i < boxes.size(); i++) {
        boxes[i]->update();
    }
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    //全てのBallのオブジェクトを描画
    for (int i = 0; i < balls.size(); i++) {
        balls[i]->draw();
    }
    
    //全てのBoxのオブジェクトを描画
    for (int i = 0; i < boxes.size(); i++) {
        boxes[i]->draw();
    }
}

//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
    //タッチムーブした時にBallオブジェクトを追加
    balls.push_back(new Ball(touch.x, touch.y));
    
    //タッチムーブした時にBoxオブジェクトを追加
    boxes.push_back(new Box(touch.x, touch.y));
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}