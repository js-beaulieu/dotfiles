#!/bin/sh

player_status=$(playerctl status 2> /dev/null)
text="No media playing"

if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
    text="$(playerctl metadata title) | $(playerctl metadata artist)"
fi

formatted=$(echo "$text" | cut -c 1-60)
if [ "$formatted" != "$text" ]; then
    formatted="$formatted..."
fi
echo $formatted

