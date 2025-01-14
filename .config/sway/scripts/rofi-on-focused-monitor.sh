#!/usr/bin/env bash

monitor=$(swaymsg -t get_workspaces | grep -C 5 '"focused": true' | grep output | cut -d '"' -f 4)

if [ $monitor == "DP-2" ]; then
	rofiSpawn=1
else
	rofiSpawn=0
fi

XDG_CURRENT_DESKTOP=KDE rofi -show drun -monitor $rofiSpawn
