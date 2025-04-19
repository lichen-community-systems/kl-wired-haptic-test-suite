# Wired Haptic Test Suite

This repository contains a collection of test tools used when setting up a wired haptic installation.

## RES(is)T Haptic Chairs

To run the RES(is)T haptic chair test tool, you'll need [SuperCollider](https://supercollider.github.io/) installed. It works on macOS, Windows, and Linux.

On Linux, ensure that you also have [JACK](https://jackaudio.org/) installed, configured for your multichannel interface as the default device, and running.

From the commandline:
```shell
./run-sc.sh resist-chairs-channel-test.scd
```
Or, from the SuperCollider GUI:
1. Open the SuperCollider application
2. Open ```resist-chairs-channel-test.scd``` in SuperCollider
3. Select the entire contents of the file
4. Press Ctrl-Enter (or Cmd-Enter on macOS) to execute the code

