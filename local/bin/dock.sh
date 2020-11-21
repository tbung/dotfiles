#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

polybar level &
# pgrep spotify && polybar player &
# polybar open &
# Wait until the control has started
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    export MONITOR=$m
    # polybar control &
    polybar workspace &
    polybar status &
    polybar music &
    # polybar power &
  done
else
    # polybar control &
    polybar workspace &
    polybar status &
    polybar music &
    # polybar power &
fi

sleep 2
polybar-msg cmd hide &
