
#pragma once

#include "ofMain.h"

#include "ofxPd.h"

// a namespace for the Pd types
using namespace pd;

class LibPd : public PdReceiver, public PdMidiReceiver {
    
public:
    
    void setup(const int numOutChannels, const int numInChannels,
               const int sampleRate, const int ticksPerBuffer);
    void exit();
    void audioReceived(float * input, int bufferSize, int nChannels);
    void audioRequested(float * output, int bufferSize, int nChannels);
    
    void sendFreq1(float f);
    void sendFreq2(float f);
    
    //-----------------------------------------------
    // pd message receiver callbacks
    void print(const std::string& message);
    
    void receiveBang(const std::string& dest);
    void receiveFloat(const std::string& dest, float value);
    void receiveSymbol(const std::string& dest, const std::string& symbol);
    void receiveList(const std::string& dest, const List& list);
    void receiveMessage(const std::string& dest, const std::string& msg, const List& list);
    
    // pd midi receiver callbacks
    void receiveNoteOn(const int channel, const int pitch, const int velocity);
    void receiveControlChange(const int channel, const int controller, const int value);
    void receiveProgramChange(const int channel, const int value);
    void receivePitchBend(const int channel, const int value);
    void receiveAftertouch(const int channel, const int value);
    void receivePolyAftertouch(const int channel, const int pitch, const int value);
    
    void receiveMidiByte(const int port, const int byte);
    
private:
    
    ofxPd pd;
    
};
