#!/bin/bash

device=$(xinput list | grep -e "Touchpad" | grep -oP 'id=\K\d+')
state=$(xinput list-props "$device" | grep "Device Enabled" | grep -o "[01]$")

if [[ "$state" -eq '1' ]]; then
  xinput --disable "$device"
else
  xinput --enable "$device"
fi
