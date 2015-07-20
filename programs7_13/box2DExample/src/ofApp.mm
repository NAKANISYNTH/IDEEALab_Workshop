#include "ofApp.h"

//--------------------------------------------------------------
void ofApp::setup(){
    
    ofSetVerticalSync(true); //trueにするとフレームレートに処理速度を合わせるらしい　詳しくはhttp://whitacirno.blog45.fc2.com/blog-entry-281.html
    ofBackgroundHex(0xfdefc2);
    
    //box2dの初期化
    box2d.init(); //初期化
    box2d.setGravity(0, 10); //重力の設定　x, y
    box2d.createBounds(); //画面の上下左右に壁を作る　createGroundで画面の下だけに壁を作ることもできる
    box2d.setFPS(60.0);
    box2d.registerGrabbing(); //生成したオブジェクトをドラッグできる設定
    
    
    //ofxUIの初期化
    gui = new ofxUICanvas();
    vector<string> names; //ラジオボタン用のstringのベクター配列
    names.push_back("CIRCLE");
    names.push_back("BOX");
    gui->setFont("TSTARPRO-Bold.otf"); //フォント設定
    gui->setRetinaResolution(); //レティナ用にguiのサイズを変える関数
    gui->addLabel("OFXUI TUTORIAL", OFX_UI_FONT_LARGE); //ラベル追加
    gui->addRadio("MODE", names); //ラジオボタン追加
    gui->autoSizeToFitWidgets(); //サイズをオートにする
    ofAddListener(gui->newGUIEvent, this, &ofApp::guiEvent); //guiEventという関数をofxUIのイベントを処理する関数に設定
    gui->loadSettings("settings.xml"); //設定が保存されるxmlファイルを読み込み
    
    
    ofxAccelerometer.setup(); //加速度計を使うための初期化
}

//--------------------------------------------------------------
void ofApp::update(){
    box2d.update(); //box2dの世界をアップデート
    box2d.setGravity(ofxAccelerometer.getForce().x*50, -ofxAccelerometer.getForce().y*50); //box2dの重力が実際の重力に同期するようにしている　50は任意の数
    
}

//--------------------------------------------------------------
void ofApp::draw(){
    
    
    for(int i=0; i<circles.size(); i++) { //サークルを全て描画
        ofFill();
        ofSetHexColor(0xf6c738);
        circles[i].get()->draw();
    }
    
    for(int i=0; i<boxes.size(); i++) { //ボックスを全て描画
        ofFill();
        ofSetHexColor(0xBF2545);
        boxes[i].get()->draw();
    }
    
    // draw the ground
    box2d.drawGround(); //壁の描画
    
    
    //情報をテキストで表示
    string info = "";
    info += "Total Bodies: "+ofToString(box2d.getBodyCount())+"\n";
    info += "Total Joints: "+ofToString(box2d.getJointCount())+"\n\n";
    info += "FPS: "+ofToString(ofGetFrameRate(), 1)+"\n";
    ofSetHexColor(0x444342);
    ofDrawBitmapString(info, 30, 30);
}


//--------------------------------------------------------------
void ofApp::exit(){

}

//--------------------------------------------------------------
void ofApp::touchDown(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchMoved(ofTouchEventArgs & touch){
    
    //ドラッグしたときにオブジェクトを追加する。UIで選んだモードによってサークルかボックスが生成される
    if (mode == CIRCLE_MODE) {
        float r = ofRandom(4, 20);
        circles.push_back(shared_ptr<ofxBox2dCircle>(new ofxBox2dCircle)); //新しいオブジェクトを配列に追加
        circles.back().get()->setPhysics(3.0, 0.53, 0.1); //パラメータを設定。　 density, bounce, friction
        circles.back().get()->setup(box2d.getWorld(), mouseX, mouseY, r); //位置や大きさなど初期化の処理
    }
    else if (mode == BOX_MODE) {
        float w = ofRandom(4, 20);
        float h = ofRandom(4, 20);
        boxes.push_back(shared_ptr<ofxBox2dRect>(new ofxBox2dRect));
        boxes.back().get()->setPhysics(3.0, 0.53, 0.1);
        boxes.back().get()->setup(box2d.getWorld(), mouseX, mouseY, w, h);
    }
    
}

//--------------------------------------------------------------
void ofApp::touchUp(ofTouchEventArgs & touch){

}

//--------------------------------------------------------------
void ofApp::touchDoubleTap(ofTouchEventArgs & touch){

}


void ofApp::guiEvent(ofxUIEventArgs &e){
    if (e.getName() == "CIRCLE") {
        mode = CIRCLE_MODE;
    }
    else if (e.getName() == "BOX") {
        mode = BOX_MODE;
    }
}