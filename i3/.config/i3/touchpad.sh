#!/bin/bash

device=$(xinput list | grep -e "Touchpad" | grep -oP 'id=\K\d+')
state=$(xinput list-props "$device" | grep "Device Enabled" | grep -o "[01]$")

if [[ "$state" -eq '1' ]]; then
  xinput --disable "$device"
  notify-send -t 1000 "Touchpad is disabled"
else
  xinput --enable "$device"
  notify-send -t 1000 "Touchpad is enabled"
fi
