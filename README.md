# ST SDL - simple terminal for RetroFW/OpenDingux

Modified to run on RS-97.
=> line doubling to deal with the 320x480 resolution
=> TTF fonts replaced by embedded pixel font (from TIC-80)
=> onscreen keyboard (see keyboard.c for button bindings)

Keys:
- pad: select key
- A: press key
- B: toggles key (useful for shift/ctrl...)
- L: is shift
- R: is backspace
- Y: change keyboard location (top/bottom)
- X: show / hide keyboard
- SELECT: quit


## Building

To build for RetroFW, run:

~~~bash
BUILDROOT=<path to buildroot> ./build.sh retrofw
~~~

The package will be built at `build-retrofw/commander-retrofw.opk`.

To build for RG350/GKD350h, run:

~~~bash
BUILDROOT=<path to buildroot> ./build.sh rg350
~~~

To build for the host system, run:

~~~bash
./build-host.sh
~~~

Here is how you can try it out on your Linux machine:

~~~bash
./build-host.sh -DSCREEN_WIDTH=640 -DSCREEN_HEIGHT=480 -DTERMNAME='"xterm-256color"' && PWD=build build/st
~~~

Use backtick to toggle virtual keyboard.

## Credits

Based on  Aurélien APTEL <aurelien dot aptel at gmail dot com> bt source code.
