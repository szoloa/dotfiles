#!/usr/bin/bash

# Use wmenu and kd to give quick access 
# of dict.
# recommand to bind with a specical key.
# Such as: bindsym $mod+w exec "/path/to/dict.sh"

word=$(: | wmenu -p "Dict " -f "JetBrains Mono 16")
rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $word == "" ]]; then 
    word=$(wl-paste)
fi 

if [[ $(kd $word) == "Not found"* ]]; then
  notify-send "not found"
else
  kitty --class 'kitty-float' kd $word
fi
