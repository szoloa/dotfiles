#!/bin/bash

# Use Playerctl to show the rate of media.
# See waybar config.

# Check if a player is running and get its status
player_status=$(playerctl status 2>/dev/null)

if [[ "$player_status" == "Playing" || "$player_status" == "Paused" ]]; then
    # Get metadata
    position=$(playerctl position)
    duration_us=$(playerctl metadata mpris:length)

    # Check if duration is available (for streams it might not be)
    if [ -n "$duration_us" ]; then
        duration_s=$((duration_us / 1000000))
        position_int=${position%.*}

        # Avoid division by zero
        if (( duration_s > 0 )); then
            percent=$(echo "scale=0;100 * $position_int / $duration_s" | bc)
        else
            percent=0
        fi

        # Format time as MM:SS
        position_f=$(date -u -d @"$position_int" +'%M:%S')
        duration_f=$(date -u -d @"$duration_s" +'%M:%S')
        
        # Output JSON for Waybar
        echo Rate "$percent"%
    else
        # Handle streams or players without duration
        tooltip_text=$(printf "%s - %s" "$artist" "$title")
    fi
else
    # No player is active
    echo 
fi
