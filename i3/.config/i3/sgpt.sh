#!/usr/bin/bash

promt=$(: | rofi -dmenu -p "chat ") rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

kitty --class="kitty-floating" sgpt_pause "$promt"
