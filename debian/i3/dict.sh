#!/usr/bin/bash

word=$(: | rofi -dmenu -p "dict ")
rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $(kd $word) == "Not found"* ]]; then
  notify-send "not found"
else
  alacritty --class='kitty-floating' --command kd $word
  echo $word >> ~/Documents/notes/words-$(date +%d-%m).txt
fi
