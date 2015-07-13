#include "ofMain.h"
#include "ofApp.h"
#include "ofxiOSAdjustWindow.h"

int main(){
//	ofSetupOpenGL(1024,768,OF_FULLSCREEN);			// <-------- setup the GL context
    
    ofxiOSAdjustWindow aw;

	ofRunApp(new ofApp());
}
