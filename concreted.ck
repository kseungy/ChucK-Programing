//2017015923 kim seung yeon
36 => int C2;  48 => int C3;  60 => int C4;  72 => int C5;  84 => int C6;
37 => int Cs2; 49 => int Cs3; 61 => int Cs4; 73 => int Cs5; 85 => int Cs6;
37 => int Db2; 49 => int Db3; 61 => int Db4; 73 => int Db5; 85 => int Db6;
38 => int D2;  50 => int D3;  62 => int D4;  74 => int D5;  86 => int D6;
39 => int Ds2; 51 => int Ds3; 63 => int Ds4; 75 => int Ds5; 87 => int Ds6;
39 => int Eb2; 51 => int Eb3; 63 => int Eb4; 75 => int Eb5; 87 => int Eb6;
40 => int E2;  52 => int E3;  64 => int E4;  76 => int E5;  88 => int E6;
41 => int F2;  53 => int F3;  65 => int F4;  77 => int F5;  89 => int F6;
42 => int Fs2; 54 => int Fs3; 66 => int Fs4; 78 => int Fs5; 90 => int Fs6;
42 => int Gb2; 54 => int Gb3; 66 => int Gb4; 78 => int Gb5; 90 => int Gb6;
43 => int G2;  55 => int G3;  67 => int G4;  79 => int G5;  91 => int G6;
44 => int Gs2; 56 => int Gs3; 68 => int Gs4; 80 => int Gs5; 92 => int Gs6;
44 => int Ab2; 56 => int Ab3; 68 => int Ab4; 80 => int Ab5; 92 => int Ab6;
45 => int A2;  57 => int A3;  69 => int A4;  81 => int A5;  93 => int A6;
46 => int As2; 58 => int As3; 70 => int As4; 82 => int As5; 94 => int As6;
46 => int Bb2; 58 => int Bb3; 70 => int Bb4; 82 => int Bb5; 94 => int Bb6;
47 => int B2;  59 => int B3;  71 => int B4;  83 => int B5;  95 => int B6;
-1 => int REST;

MidiOut mout;
MidiMsg msg;
MidiMsg msg2;

Gain master => dac;
SndBuf hihat => master;
SndBuf snare => master;
me.dir() + "/audio/hihat_03.wav" => hihat.read;
me.dir() + "/audio/snare_03.wav" => snare.read;
hihat.samples() => hihat.pos;
snare.samples() => snare.pos;

1 => int port;
if (!mout.open(port)) {
    <<< "Error: MIDI port did not open on port: ", port >>>;
    me.exit();
}

0.16::second => dur BEAT;
BEAT => dur SN; // sixth note (1/6)
BEAT * 2 => dur TN; // third note (1/3)
BEAT * 3 => dur HN; // half note (1/2)
BEAT * 8 => dur WN; // whole note (1)
BEAT * 6 => dur THN;
BEAT * 4 => dur FN;
BEAT/4 => dur RN;

[
C5,B4,A4,G4,F4, REST,G4,A4,C5, B4,A4,G4,F4,E4, REST,REST,
A4,G4,F4,E4,D4, REST,E4,F4,A4, Gs4,F4,E4,D4,C4, REST
]@=> int MELODY[];


[
A3,-1,-1,-1,-1, D3,-1,-1,-1, G3,-1,-1,-1,-1, C3,-1,
F3,-1,-1,-1,-1, B2,-1,-1,-1,E3,-1,-1,-1,-1, A2
]@=> int BASS[];

[
HN,SN,TN,SN,SN, SN,HN,TN,TN, HN,SN,TN,SN,SN, WN,TN,
HN,SN,TN,SN,SN, SN,HN,TN,TN, HN,SN,TN,SN,SN, THN
]@=> dur DURS[];


int note, vol;
fun void righthand() {
    for(0 => int i; i<MELODY.size(); i++){
    MELODY[i] => note;
    50 => vol;
    setOsc(note, vol);
    DURS[i] => now;
    0.1::second => now;
    }
}

fun void lefthand() {
    for(0 => int i; i<BASS.size(); i++){
    BASS[i] => note;
    50 => vol;
    setOsc(note, vol);
    DURS[i] => now;
    0.1::second => now;
    }
}

fun void drum(){
    0.4::second => dur TEMPO;
    0.24::second => dur TEMPO2;

    [1,0,0, 1,0,0, 1,0,0] @=> int hihat_hits[];
    [0,1,1, 0,1,1, 0,1,1] @=> int snare_hits[];  
    
    while (true) {
    for (0 => int beat; beat < hihat_hits.size(); beat++) {
        if (hihat_hits[beat]){ 
            0 => hihat.pos;
            0.15=>hihat.gain;
            TEMPO => now;
        }
        if (snare_hits[beat]){ 
            0 => snare.pos;
            0.15=>snare.gain;
            TEMPO2 => now;
        }
    }
  }
}

fun void setOsc(int note, int vol) {
    if (note == -1) {
        128 => msg.data1;
      0 => msg.data2;
      <<< "note =", "rest (zzz...)" >>>;
    }
    else {
        144 => msg.data1;
        note => msg.data2;
        vol => msg.data3;
        <<< "note =", note, "volume =", vol >>>;
    }
    mout.send(msg);
}

spork~righthand();
spork~lefthand();
spork~drum();
14::second => now;