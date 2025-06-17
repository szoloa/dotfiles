#!/usr/bin/bash

word=$(: | wofi -dmenu -p "dict ")
rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $(kd $word) == "Not found"* ]]; then
  notify-send "not found"
else
  kitty --class 'kitty-float' kd $word
fi
