//
//  Box.cpp
//  ballAnimation
//
//  Created by kyosuke on 7/13/15.
//
//

#include "Box.h"

Box::Box(int x, int y):Ball(x, y){ //Boxクラスのコンストラクタで取得したｘ，ｙを継承したBallクラスのコンストラクタにも代入している
    
}

void Box::draw(){
    ofRect(position, ofRandom(10), ofRandom(10)); //rectの描画
}