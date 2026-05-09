#!/bin/sh

# See niri and mako config.

# Get the volume level and convert it to a percentage
volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
volume=$(echo "$volume" | awk '{print $2}')
volume=$(echo "( $volume * 100 ) / 1" | bc)

echo "$volume" | wob -m -p "Volume: ${volume}%"
