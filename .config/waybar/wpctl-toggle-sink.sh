#!/bin/sh

sinks=($(wpctl status | awk '/Audio/,/Streams/' | grep "Sinks:" -A 2 | grep -oP '^\s*│\s+\*?\s*\K\d+(?=\.)'))
if wpctl inspect @DEFAULT_AUDIO_SINK@ | head -1 | grep "${sinks[0]}" -q; then
    wpctl set-default "${sinks[1]}"
else
    wpctl set-default "${sinks[0]}"
fi
