#!/usr/bin/bash

word=$(: | rofi -dmenu -p "dict ")
rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $(kd $word) == "Not found"* ]]; then
  notify-send "not found"
else
  kitty --class 'kitty-floating' kd $word
fi
