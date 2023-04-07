SynthDef(\fm_synth, { |out = 0, freq = 440, amp = 0.1, mod_freq_ratio = 1, mod_index = 1|
	var carrier, modulator, mod_signal, audio_out;

	carrier = SinOsc.ar(freq);
	modulator = SinOsc.ar(freq * mod_freq_ratio);

	mod_signal = modulator * mod_index * freq;

	audio_out = SinOsc.ar(carrier + mod_signal) * amp;

	Out.ar(out, audio_out);
}).add;

x = Synth(\fm_synth, [\freq, 60, \amp, 0.1, \mod_freq_ratio, 5, \mod_index, 10]);

x.free;

(
var createFMsynth;
createFMsynth = {
    Synth(\fm_synth, [\freq, 440, \amp, 0.1, \mod_freq_ratio, 2, \mod_index, 5]);
};
x = createFMsynth.();
)

(
var window, freq_slider, amp_slider, mod_freq_ratio_slider, mod_index_slider;

window = Window.new("FM Synth", Rect(100, 100, 400, 300)).front;
window.view.layout = VLayout(
    HLayout(
        StaticText.new(window, "Frequency: "),
        freq_slider = Slider.new(window, Rect(0, 0, 300, 20))
            .value_(0.5)
            .action_({ |slider|
                x.set(\freq, slider.value.linexp(0, 1, 20, 2000));
            }),
    ),
    HLayout(
        StaticText.new(window, "Amplitude: "),
        amp_slider = Slider.new(window, Rect(0, 0, 300, 20))
            .value_(0.1)
            .action_({ |slider|
                x.set(\amp, slider.value);
            }),
    ),
    HLayout(
        StaticText.new(window, "Mod Freq Ratio: "),
        mod_freq_ratio_slider = Slider.new(window, Rect(0, 0, 300, 20))
            .value_(0.5)
            .action_({ |slider|
                x.set(\mod_freq_ratio, slider.value.linexp(0, 1, 0.1, 10));
            }),
    ),
    HLayout(
        StaticText.new(window, "Mod Index: "),
        mod_index_slider = Slider.new(window, Rect(0, 0, 300, 20))
            .value_(0.5)
            .action_({ |slider|
                x.set(\mod_index, slider.value.linexp(0, 1, 2, 50));
            }),
    ),
);
)
