//
//  particle.cpp
//  drawingApp
//
//  Created by kyosuke on 7/1/15.
//
//

#include "particle.h"

particle::particle(ofVec2f pos){
    positon = pos;
    velocity = ofVec2f(ofRandom(-3,3), ofRandom(-3,3));
}

void particle::setup(){
    positon = ofVec2f(ofGetWidth()/2, ofGetHeight()/2);
    velocity = ofVec2f(1,1);
}

//--------------------------------------------------------------
void particle::update(){
    positon += velocity;
}

//--------------------------------------------------------------
void particle::draw(){
    ofCircle(positon, 5);
}