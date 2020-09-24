# ENABLES -> NaturalScrolling and Click-on-Tap emulation

# TOUCHPAD
FOLDER="/etc/X11/xorg.conf.d"
FILE="30-touchpad.conf"

config="Section \"InputClass\" \n
            \t Identifier \"touchpad\" \n
            \t MatchisTouchPad \"on\" \n
            \t Driver \"libinput\" \n
            \t Option \"NaturalScrolling\" \"true\" \n
            \t Option \"Tapping\" \"on\" \n
EndSection"

mkdir -p $FOLDER
echo $config > "$FOLDER/$FILE"
