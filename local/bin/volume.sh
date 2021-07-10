#!/bin/bash

# Replace if already running
running=$(pidof -x $0)

while [ "$(echo $running| wc -w)" -gt "1" ]; do
	oldprocess=$(echo $running| rev| cut -d' ' -f1| rev)
	kill $oldprocess
	running=$(pidof -x $0)
done

monitor=$(bspc query -M -m focused --names)
monitorid=$(xrandr --listmonitors | grep $monitor | sed 's/.*\([0-9]\):.*/\1/g')

state=$(eww windows | grep volume)
if [[ $state == \** ]]; then
    echo 'yes'
else
    eww open --monitor $monitorid volume
fi

sleep 0.8
eww close volume
