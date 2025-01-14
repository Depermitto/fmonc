#! /usr/bin/bash
#
# Restart rgb peripherals and then kill all openrgb clients.

openrgb --server &
sleep 16
pkill 'openrgb'
