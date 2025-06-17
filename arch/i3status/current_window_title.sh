#!/bin/bash
title=$(i3-msg -t get_tree | jq -r '.. | select(.focused? == true).name')
echo "{\"name\":\"current_window_title\",\"full_text\":\"$title\",\"color\":\"#ffffff\"}"

