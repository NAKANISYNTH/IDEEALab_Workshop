
#include "LibPd.h"

//--------------------------------------------------------------
void LibPd::setup(const int numOutChannels, const int numInChannels,
                  const int sampleRate, const int ticksPerBuffer) {
    
    ofSetFrameRate(60);
    ofSetVerticalSync(true);
    //ofSetLogLevel(OF_LOG_VERBOSE);
    
    // double check where we are ...
    cout << ofFilePath::getCurrentWorkingDirectory() << endl;
    
    if(!pd.init(numOutChannels, numInChannels, sampleRate, ticksPerBuffer)) {
        OF_EXIT_APP(1);
    }
    
    
    // add message receiver, disables polling (see processEvents)
    pd.addReceiver(*this);   // automatically receives from all subscribed sources
    
    // audio processing on
    pd.start();
    Patch patch = pd.openPatch("pd/example_0731.pd"); //**************pdのファイルを開く
}

//**************1つめのpdに周波数となる値を送る関数**************
void LibPd::sendFreq1(float f){
    pd.sendFloat("freq1", f); //freq1はpdで作ったレシーバー[r freq1]の名前
}

//**************2つめのpdに周波数となる値を送る関数**************
void LibPd::sendFreq2(float f){
    pd.sendFloat("freq2", f);
}

void LibPd::exit() {}
//--------------------------------------------------------------
void LibPd::audioReceived(float * input, int bufferSize, int nChannels) {
    //    pd.audioIn(input, bufferSize, nChannels);
}

//--------------------------------------------------------------
void LibPd::audioRequested(float * output, int bufferSize, int nChannels) {
    pd.audioOut(output, bufferSize, nChannels);
}

//--------------------------------------------------------------
void LibPd::print(const std::string& message) {
    cout << message << endl;
}

//--------------------------------------------------------------
void LibPd::receiveBang(const std::string& dest) {
    cout << "OF: bang " << dest << endl;
}

void LibPd::receiveFloat(const std::string& dest, float value) {
    cout << "OF: float " << dest << ": " << value << endl;
}

void LibPd::receiveSymbol(const std::string& dest, const std::string& symbol) {
    cout << "OF: symbol " << dest << ": " << symbol << endl;
}

void LibPd::receiveList(const std::string& dest, const List& list) {
    cout << "OF: list " << dest << ": ";
}

void LibPd::receiveMessage(const std::string& dest, const std::string& msg, const List& list) {
    cout << "OF: message " << dest << ": " << msg << " " << list.toString() << list.types() << endl;
}

//--------------------------------------------------------------
void LibPd::receiveNoteOn(const int channel, const int pitch, const int velocity) {
    cout << "OF MIDI: note on: " << channel << " " << pitch << " " << velocity << endl;
}

void LibPd::receiveControlChange(const int channel, const int controller, const int value) {
    cout << "OF MIDI: control change: " << channel << " " << controller << " " << value << endl;
}

// note: pgm nums are 1-128 to match pd
void LibPd::receiveProgramChange(const int channel, const int value) {
    cout << "OF MIDI: program change: " << channel << " " << value << endl;
}

void LibPd::receivePitchBend(const int channel, const int value) {
    cout << "OF MIDI: pitch bend: " << channel << " " << value << endl;
}

void LibPd::receiveAftertouch(const int channel, const int value) {
    cout << "OF MIDI: aftertouch: " << channel << " " << value << endl;
}

void LibPd::receivePolyAftertouch(const int channel, const int pitch, const int value) {
    cout << "OF MIDI: poly aftertouch: " << channel << " " << pitch << " " << value << endl;
}

// note: pd adds +2 to the port num, so sending to port 3 in pd to [midiout],
//       shows up at port 1 in ofxPd
void LibPd::receiveMidiByte(const int port, const int byte) {
    cout << "OF MIDI: midi byte: " << port << " " << byte << endl;
}

