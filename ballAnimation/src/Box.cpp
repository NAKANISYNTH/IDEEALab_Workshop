//
//  Box.cpp
//  ballAnimation
//
//  Created by kyosuke on 7/13/15.
//
//

#include "Box.h"

Box::Box(int x, int y):Ball(x, y){
    
}

void Box::draw(){
    ofRect(position, ofRandom(10), ofRandom(10));
}