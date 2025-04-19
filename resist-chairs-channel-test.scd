s.options.numOutputBusChannels = 22;

~fundamental = 80;
~intervals = [
    1/1,
    5/3,
    3/2,
    2/1,
    5/4 + 2/1,
    3/2 + 2/1,
    3/1,
    5/4 + 3/2
];

~renderUI = {
    w = Window.new(name: "Tranducer Channel Test").front();
    ~buttonWidth = 40;
    ~buttonHeight = 20;
    ~windowWidth = ~buttonWidth * 9 + (~buttonWidth / 2);
    ~windowCenter = (w.bounds.width() / 2);
    ~buttonCentered = ~windowCenter - (~buttonWidth / 2);

    ~buttonRects = [
        Rect(
            left: ~buttonCentered,
            top: ~buttonHeight * 6,
            width: ~buttonWidth,
            height: ~buttonHeight
        ),
        Rect(
            left: ~buttonWidth,
            top: ~buttonHeight * 8,
            width: ~buttonWidth,
            height: ~buttonHeight
        ),
        Rect(
            left: ~buttonCentered,
            top: ~buttonHeight * 10,
            width: ~buttonWidth,
            height: ~buttonHeight
        ),
        Rect(
            left: ~buttonWidth * 8,
            top: ~buttonHeight * 8,
            width: ~buttonWidth,
            height: ~buttonHeight
        ),
        Rect(
            left: ~buttonWidth + (~buttonWidth / 2),
            top: ~buttonHeight * 12,
            width: ~buttonWidth,
            height: ~buttonHeight
        ),
        Rect(
            left: ~buttonCentered,
            top: ~buttonHeight * 14,
            width: ~buttonWidth,
            height: ~buttonHeight
        ),
        Rect(
            left: (~buttonWidth * 8) - (~buttonWidth / 2),
            top: ~buttonHeight * 12,
            width: ~buttonWidth,
            height: ~buttonHeight
        ),
        Rect(
            left: ~buttonCentered,
            top: ~buttonHeight,
            width: ~buttonWidth,
            height: ~buttonHeight
        )
    ];

    ~channelButtons = Array.fill(8, {|i|
        Button(parent: w, bounds: ~buttonRects[i]).states_([
            ["Play"], ["Pause"]
        ]).action_({ |button|
            var amp = if(button.value == 1, 1.0, 0.0);
            var state = button.value;
            ("Transducer " + (i + 1) + ": " + state).postln;
            ~channelSynths[i].set(
                \amp, amp
            );
        });
    });

    ~droneCheckbox = CheckBox(
        parent: w,
        bounds: Rect(
            left: ~windowCenter / 2,
            top: w.bounds.height - (~buttonHeight * 2),
            width: ~buttonWidth * 2,
            height: ~buttonHeight
        ),
        text: "Drone"
    ).action = {|box|
        var steady = if(box.value, 1, 0);
        ~channelSynths.do({|synth, i|
            synth.set(
                \steady, steady
            );
        });
    };
    ~droneCheckbox.valueAction = true;

    ~spreadCheckbox = CheckBox(
        parent: w,
        bounds: Rect(
            left: ~windowCenter + (~windowCenter / 4),
            top: w.bounds.height - (~buttonHeight * 2),
            width: ~buttonWidth * 2,
            height: ~buttonHeight
        ),
        text: "Spread"
    ).action = {|box|
        if (box.value == true) {
            ~channelSynths.do({|synth, i|
                synth.set(\freq, ~fundamental * ~intervals[i]);
            });
        } {
            ~channelSynths.do({|synth|
                synth.set(\freq, ~fundamental);
            });
        };
    };
    ~spreadCheckbox = false;
};

~main = {
    SynthDef(\test, {|bus = 0, freq = 40, amp = 0.0, phase = 0.0, steady = 0|
        var env = Select.kr(which: steady, array: [
            LFPulse.ar(freq: 0.25, iphase: phase, width: 0.25, mul: 1.0),
            1.0
        ]);

        var signal = SinOsc.ar(freq: freq, mul: env * amp);

        Out.ar(bus: bus, channelsArray: [signal]);
    }).send(s);

    s.sync;

    ~channelSynths = Array.fill(8, {|i|
        Synth(\test, args: [
            \bus, i,
            \phase, 1.0 / i
        ]);
    });

    ~renderUI.value()

};

s.waitForBoot(onComplete: {
    ~main.value();
});
