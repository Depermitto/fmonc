#!/usr/bin/bash

currentCssDir=~/.config/waybar/current.css
summonWaybar="waybar --style $currentCssDir"

if ps -e | grep waybar | grep -q .; then
	pkill waybar;	$summonWaybar
else
	$summonWaybar 
fi
