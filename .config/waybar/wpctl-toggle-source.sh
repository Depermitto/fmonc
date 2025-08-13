#!/bin/sh

sources=($(wpctl status | awk '/Audio/,/Streams/' | grep "Sources:" -A 2 | grep -oP '^\s*│\s+\*?\s*\K\d+(?=\.)'))
if wpctl inspect @DEFAULT_AUDIO_SOURCE@ | head -1 | grep "${sources[0]}" -q; then
    wpctl set-default "${sources[1]}"
else
    wpctl set-default "${sources[0]}"
fi
