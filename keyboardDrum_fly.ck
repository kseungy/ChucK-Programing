//2017015923 kim seung yeon
/*
backspace: snare_03
left keys: hihat_03
*/
Hid hi;
HidMsg msg;
0 => int device; 
if (! hi.openKeyboard(device)) me.exit();
<<< "keyboard '" + hi.name() + "' ready", "" >>>;


SndBuf snare3 => dac;
me.dir() + "/audio/snare_03.wav" => snare3.read;
snare3.samples() => snare3.pos;

SndBuf hihat => dac;
me.dir() + "/audio/hihat_01.wav" => hihat.read;
hihat.samples() => hihat.pos;
     
while (true) {
    hi => now;
    while (hi.recv(msg)) {

        if(msg.ascii == 8){
            if (msg.isButtonDown()) {
                <<< "Button Down:", msg.ascii >>>;
                1 => snare3.pos;
                0.1 => snare3.gain;
                80::ms => now;
            }
        }
        else{
           if (msg.isButtonDown()) {
                <<< "Button Down:", msg.ascii >>>;
                1 => hihat.pos;
                0.1 => hihat.gain;
                80::ms => now;
            }
        } 
        
    } 
}     
