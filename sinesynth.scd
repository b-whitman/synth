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

y = Synth(\sineSynthWithLFO);

y.release;

y = nil;

   (
   var window, lfoFreqSlider, lfoDepthSlider, startButton, stopButton;

   window = Window.new("LFO Control", Rect(100, 100, 300, 300)).front;

   lfoFreqSlider = EZSlider.new(window, Rect(20, 20, 260, 40), "LFO Frequency", ControlSpec(0.1, 5, 'lin', 0.1, 2), { |slider|
       y.set(\lfoFreq, slider.value);
   });

   lfoDepthSlider = EZSlider.new(window, Rect(20, 80, 260, 40), "LFO Depth", ControlSpec(0, 100, 'lin', 1, 20), { |slider|
       y.set(\lfoDepth, slider.value);
   });

   startButton = Button(window, Rect(20, 160, 120, 40))
       .states_([["Start", Color.black, Color.white]])
       .action_({
           if (y.isNil or: { y.isPlaying.not }) {
               y = Synth(\sineSynthWithLFO);
           };
       });

   stopButton = Button(window, Rect(160, 160, 120, 40))
       .states_([["Stop", Color.black, Color.white]])
       .action_({
           y.release;
       });
   )
