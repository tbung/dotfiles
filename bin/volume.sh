#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

MAX_VOL=150

function get_volume {
    amixer get Master | grep '%' | head -n 1 | cut -d '[' -f 2 | cut -d '%' -f 1
}

function is_mute {
    amixer get Master | grep '%' | grep -oE '[^ ]+$' | grep off > /dev/null
}

function send_notification {
    volume=`get_volume`
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $(($volume / 5)) | sed 's/[0-9]//g')
    # Not space, figure space, same width as boxdrawing character
    bar=$bar$(seq -s " " $((($MAX_VOL - $volume) / 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i audio-volume-high -t 1000 -r 2593 -u normal "    $bar"
}

case $1 in
    up)
        volume=`get_volume`
	# Set the volume on (if it was muted)
	amixer -D pulse set Master on > /dev/null
	# Up the volume (+ 5%)
	# amixer -D pulse sset Master 5%+ > /dev/null
        if [[ $MAX_VOL -ge $(($volume + 5)) ]]; then
            #statements
            pactl set-sink-volume 0 +5%
        fi
	send_notification
	;;
    down)
	amixer -D pulse set Master on > /dev/null
	# amixer -D pulse sset Master 5%- > /dev/null
        pactl set-sink-volume 0 -5%
	send_notification
	;;
    mute)
    	# Toggle mute
	amixer -D pulse set Master 1+ toggle > /dev/null
	if is_mute ; then
	    dunstify -i audio-volume-muted -t 1000 -r 2593 -u normal "Mute"
	else
	    send_notification
	fi
	;;
esac
