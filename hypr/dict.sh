#!/usr/bin/bash

word=$(: | wmenu -p "Dict " -f "JetBrains Mono 11")
rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $(kd $word) == "Not found"* ]]; then
  notify-send "not found"
else
  kitty --class 'kitty-float' kd $word
fi
