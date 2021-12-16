Gain master => dac;
SndBuf hihat => master;
SndBuf snare => master;
me.dir() + "/audio/hihat_03.wav" => hihat.read;
//2017015923 kim seung yeon
me.dir() + "/audio/snare_03.wav" => snare.read;
hihat.samples() => hihat.pos;
snare.samples() => snare.pos;

0.5::second => dur TEMPO;
0.3::second => dur TEMPO2;

[1,0,0, 1,0,0, 1,0,0] @=> int hihat_hits[];
[0,1,1, 0,1,1, 0,1,1] @=> int snare_hits[];
for (0 => int beat; beat < hihat_hits.size(); beat++) {
        if (hihat_hits[beat]){ 
            0 => hihat.pos;
            0.2=>hihat.gain;
            TEMPO => now;
        }
        if (snare_hits[beat]){ 
            0 => snare.pos;
            0.2=>snare.gain;
            TEMPO2 => now;
        }
}
