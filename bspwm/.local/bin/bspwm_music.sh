#!/bin/sh

player_status=$(playerctl status 2> /dev/null)
text="No media playing"

if [ "$player_status" = "Playing" ] || [ "$player_status" = "Paused" ]; then
    # fix for YouTube Music adding " - Topic" to artist names in certain playlists
    # matching on the exact prefix at the end of the string, so unless an artist is called
    # something literally ending by this string of characters, we're fine...
    artist="$(playerctl metadata artist | sed -e 's/ - Topic$//')"
    text="$(playerctl metadata title) | $artist"
fi

formatted=$(echo "$text" | cut -c 1-60)
if [ "$formatted" != "$text" ]; then
    formatted="$formatted..."
fi
echo $formatted

