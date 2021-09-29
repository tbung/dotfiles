#!/bin/bash

if (($(bspc config -m eDP1 bottom_padding) > 0))
then
    # Polybar should be visible, let's hide it and reset bottom padding
    polybar-msg cmd hide && bspc config bottom_padding 0 && bspc config gapless_monocle true
else
    # Polybar should be hidden, let's show it, bspwm should automatically
    # adjust padding
    polybar-msg cmd show && bspc config gapless_monocle false
fi
