
/*
 飛んで行くボールのクラス
 */
#pragma once
#include "ofMain.h"

class Ball{
    
public:
    //publicの中に書いたものは他のクラスからアクセス（書き換えたり呼び出したり）することができる
    Ball(int x, int y); //最初の座標を引数にして初期化
    ~Ball();
    
    void setup();
    void update();
    virtual void draw(); //virtualをつけることで継承したクラスがこの関数を書き換えることができる
    
    
protected:
    //protectedの中に書いたものはこのクラスを継承したクラスのみからアクセス（書き換えたり呼び出したり）することができる。
    
    ofPoint position;
    ofVec2f speed;
    
private:
    //publicの中に書いたものは他のクラスからアクセス（書き換えたり呼び出したり）することができない
    
};