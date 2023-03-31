(
   SynthDef(\sineSynth, {
       |out = 0, freq = 100, amp = 0.5, gate = 1|
       var env, signal;
       env = EnvGen.kr(Env.asr(0.01, 1, 0.5), gate, doneAction: 2);
       signal = SinOsc.ar(freq, 0, amp * env);
       Out.ar(out, signal ! 2);
   }).add;
)

   (
   SynthDef(\sineSynthWithLFO, {
       |out = 0, freq = 440, amp = 0.5, gate = 1, lfoFreq = 1, lfoDepth = 20|
       var env, signal, lfo;
       env = EnvGen.kr(Env.asr(0.01, 1, 0.5), gate, doneAction: 2);
       lfo = SinOsc.kr(lfoFreq) * lfoDepth;
       signal = SinOsc.ar(freq + lfo, 0, amp * env);
       Out.ar(out, signal ! 2);
   }).add;
   )

x = Synth(\sineSynth);
y = Synth(\sineSynthWithLFO);

/*x.set(\freq, 100);*/

x.release;
y.release;

(
   var window, lfoFreqSlider, lfoDepthSlider;

   window = Window.new("LFO Control", Rect(100, 100, 300, 200)).front;

   lfoFreqSlider = EZSlider.new(window, Rect(20, 20, 260, 40), "LFO Frequency", ControlSpec(0.1, 20, 'lin', 0.1, 5), { |slider|
       y.set(\lfoFreq, slider.value);
   });

   lfoDepthSlider = EZSlider.new(window, Rect(20, 80, 260, 40), "LFO Depth", ControlSpec(0, 100, 'lin', 1, 20), { |slider|
       y.set(\lfoDepth, slider.value);
   });
   )