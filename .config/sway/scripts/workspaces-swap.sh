#!/usr/bin/env bash

if [  $(swaymsg -t get_outputs | jq '.[].id' | wc -l) -gt 1 ]; then
	# Variables
	monitor1=$(swaymsg -t get_outputs --raw | jq '.[0].name' -r)
	monitor2=$(swaymsg -t get_outputs --raw | jq '.[1].name' -r)
	workspace1=$(swaymsg -t get_outputs --raw | jq '.[0].current_workspace' -r)
	workspace2=$(swaymsg -t get_outputs --raw | jq '.[1].current_workspace' -r)


	# The meat the potatoes of the script. Move all $focusedContainers to the $secondScreenWorkspace and vice versa.
	swaymsg workspace $workspace1
	swaymsg move workspace to output $monitor2
	swaymsg workspace $workspace2
	swaymsg move workspace to output $monitor1
fi
