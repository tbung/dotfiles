#!/usr/bin/env bash

DISPLAY_RE="([0-9]+)x([0-9]+)\\+([0-9]+)\\+([0-9]+)"
LOCK_IMG="$HOME/.i3/lock_icon.png"
BG_IMG='/tmp/screen.png'
FONT='Ubuntu'
TEXT='Type password to unlock'

(( $# )) && { LOCK_IMG=$1; }

SCREEN_WIDTH=0

#Execute xrandr to get information about the monitors:
while read LINE
do
  #If we are reading the line that contains the position information:
  if [[ $LINE =~ $DISPLAY_RE ]]; then
    #Extract information and append some parameters to the ones that will be given to ImageMagick:
    SCREEN_X=${BASH_REMATCH[3]}
    SCREEN_Y=${BASH_REMATCH[4]}

    if [[ $SCREEN_X -gt 0 ]]; then
        SCREEN_WIDTH=${BASH_REMATCH[1]}
    fi
  fi
done <<<"`xrandr`"


scrot "$BG_IMG"

convert "$BG_IMG" -blur 0x6 -define modulate:colorspace=HSB -modulate 60 "$BG_IMG"
convert "$BG_IMG" "$LOCK_IMG" -gravity center \
    -geometry  "-$(($SCREEN_WIDTH/2))+0" -composite -matte -font "$FONT" \
    -pointsize 26 -fill white -annotate "-$(($SCREEN_WIDTH/2))+160" "$TEXT" "$BG_IMG"
i3lock --screen 2 -n -i "$BG_IMG" \
    --insidecolor=37344500 --ringcolor=ffffffff --line-uses-inside \
    --keyhlcolor=282936ff --bshlcolor=d23c3dff --separatorcolor=00000000 \
    --insidevercolor=55ea3400 --insidewrongcolor=d23c3d88 \
    --ringvercolor=ffffffff --ringwrongcolor=ffffffff --indpos="w/2:h/2" \
    --radius=80 --veriftext="" --wrongtext="" --indicator --ring-width=12 \
    --noinputtext=""
