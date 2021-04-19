#!/usr/bin/env bash

CURRENT_LAYOUT=$(setxkbmap -query | grep layout | awk '{print $2}')
if [ $CURRENT_LAYOUT = "us" ]; then
    TARGET_LAYOUT="ca multix"
else
    TARGET_LAYOUT="us"
fi

setxkbmap $TARGET_LAYOUT

