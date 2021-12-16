# ChucK-Programing
MidiOut mout;
MidiMsg msg;
MidiMsg msg2;

1 => int port;
if (!mout.open(port)) {
    <<< "Error: MIDI port did not open on port: ", port >>>;
    me.exit();
}

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
0.15::second => dur BEAT;
BEAT => dur SN; // sixth note (1/6)
BEAT * 2 => dur TN; // third note (1/3)
BEAT * 3 => dur HN; // half note (1/2)
BEAT * 8 => dur WN; // whole note (1)
BEAT * 6 => dur THN;
BEAT * 4 => dur FN;
BEAT/4 => dur RN;

[
C5,B4,A4,G4,F4, REST,G4,A4,C5, B4,A4,G4,F4,E4, REST, REST,
A4,G4,F4,E4,D4, REST,E4,F4,A4, Gs4,F4,E4,D4,C4, REST, Cs4,
D4,A4,A4,REST, REST,C5,B4, G4, REST,B3,
C4,F4,F4,REST, REST,A4,G4, F4,E4,REST, REST, REST,
C5,B4,A4,G4,F4, REST,G4,A4,C5, B4,A4,G4,F4,E4, REST,
A4,G4,F4,E4,D4, REST,E4,F4,A4, Gs4,F4,E4,D4,C4, REST,Cs4,
D4,A4,A4,REST, REST,C5,B4,G4, REST,Gs4,
A4,C4,C4,REST, REST,C4,D4, C4, REST,
E5, REST,C5, D5,A4,A4,REST, REST,B4,D5, C5, REST
]@=> int MELODY[];

[
HN,SN,TN,SN,SN, SN,HN,TN,TN, HN,SN,TN,SN,SN, WN, TN,
HN,SN,TN,SN,SN, SN,HN,TN,TN, HN,SN,TN,SN,SN, THN, TN,
SN,TN,SN,FN, FN,TN,TN, WN, THN,TN,
SN,TN,SN,WN, TN,WN,TN, HN,SN,FN, FN, FN,
HN,SN,TN,SN,SN, SN,HN,TN,TN, HN,SN,TN,SN,SN, WN,
HN,SN,TN,SN,SN, SN,HN,TN,TN, HN,SN,TN,SN,SN, THN,TN,
SN,TN,SN,FN, TN,FN,TN, WN, THN, TN,
SN,TN,SN,FN, FN,TN,TN, WN, FN,
WN, THN,TN, SN,TN,SN,FN, FN,TN,TN, WN, WN
]@=> dur DURS[];

[
A3,-1,-1,-1,-1, D3,-1,-1,-1, G3,-1,-1,-1,-1, C3,-1,
F3,-1,-1,-1,-1, B2,-1,-1,-1,E3,-1,-1,-1,-1, A2, -1,
D2,-1,-1,-1, G3,-1,-1, C3, E3,-1,
D2,-1,-1,-1, G3,-1,-1, C3,-1,-1, B2, E3,
A3,-1,-1,-1,-1, D3,-1,-1,-1, G3,-1,-1,-1,-1, C3,
F3,-1,-1,-1,-1, B2,-1,-1,-1,E3,-1,-1,-1,-1, A2, -1,
D2,-1,-1,-1, G3,-1,-1,E3, A3,-1,
D2,-1,-1,-1, G3,-1,-1, C3, B2,
E3, A3,-1, D2,-1,-1,-1, G3,-1,-1, C3, -1
]@=> int BASS[];

int note, note2, vol;
for(0 => int i; i<MELODY.size(); i++){
    MELODY[i] => note;
    BASS[i]=> note2;
    50 => vol;
    setOsc(note, vol);
    setOsc(note2, vol);
    DURS[i] => now;
    0.1::second => now;
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
