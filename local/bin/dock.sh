#!/bin/sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# polybar level &
# ln -s /tmp/polybar_mqueue.$! /tmp/ipc-polybar-level
# pgrep spotify && polybar player &
# polybar open &
# Wait until the control has started
if type "xrandr"; then
  for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar status &
    MONITOR=$m polybar music &
    MONITOR=$m polybar workspace &
  done
else
    polybar workspace &
    polybar status &
    polybar music &
fi
