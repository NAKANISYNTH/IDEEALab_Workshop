
#pragma once
#include "Ball.h"

class Box : public Ball{ //Ballクラスをpublicで継承。publicとprotectedで指定された変数、関数にアクセスできる。詳細についてはhttp://bituse.info/cp/5を参照
    
public:
    Box(int x, int y); //コンストラクタ
    void draw(); //Ballクラスでdraw関数はvirtualになているので上書き可能
    
private:
    
    
};