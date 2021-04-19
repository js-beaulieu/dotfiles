#! /bin/sh

killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | grep "primary" | cut -d" " -f1); do
    MONITOR=$m polybar --reload main &
  done
  for m in $(xrandr --query | grep " connected" | grep -v "primary" | cut -d" " -f1); do
    MONITOR=$m polybar --reload bar1 &
  done
else
  polybar --reload bar1 &
fi

