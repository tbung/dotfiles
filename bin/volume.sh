#!/bin/bash

# You can call this script like this:
# $./volume.sh up
# $./volume.sh down
# $./volume.sh mute

MAX_VOL=150

function send_notification {
    volume=$(pamixer --get-volume)
    # Make the bar with the special character ─ (it's not dash -)
    # https://en.wikipedia.org/wiki/Box-drawing_character
    bar=$(seq -s "─" $((($volume + 5)/ 5)) | sed 's/[0-9]//g')
    # Not space, figure space, same width as boxdrawing character
    bar=$bar$(seq -s " " $((($MAX_VOL - $volume + 5) / 5)) | sed 's/[0-9]//g')
    # Send the notification
    dunstify -i audio-volume-high -t 1000 -r 2593 -u normal "    $bar"
}

case $1 in
    up)
        volume=$(pamixer --get-volume)
	# Set the volume on (if it was muted)
        pamixer -u
	# Up the volume (+ 5%)
	# amixer -D pulse sset Master 5%+ > /dev/null
        if [[ $MAX_VOL -ge $(($volume + 5)) ]]; then
            #statements
            # pactl set-sink-volume 0 +5%
            pamixer --allow-boost -i 5
        fi
	send_notification
	;;
    down)
        pamixer -u
	# amixer -D pulse sset Master 5%- > /dev/null
        # pactl set-sink-volume 0 -5%
        pamixer --allow-boost -d 5
	send_notification
	;;
    mute)
    	# Toggle mute
        if $(pamixer --get-mute) ; then
            pamixer -u
	    send_notification
	else
            pamixer -m
	    dunstify -i audio-volume-muted -t 1000 -r 2593 -u normal "Mute"
	fi
	;;
esac
