

#include "Ball.h"


Ball::Ball(int x, int y){
    position = ofPoint(x, y);
    speed = ofVec2f(ofRandom(-5, 5), ofRandom(-5,5));
}

Ball::~Ball(){
    
}

void Ball::setup(){
    
}

void Ball::update(){
    position += speed;
}

void Ball::draw(){
    ofCircle(position, ofRandom(10)); //circleの描画
}