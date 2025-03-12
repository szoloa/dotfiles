#!/usr/bin/bash

url=$(: | rofi -dmenu -p "url ") rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $url == https://* ]]; then
  google-chrome-stable --class="chrome-floating" --new-window "$url"
else
  google-chrome-stable --class="chrome-floating" --new-window "https://google.com/search?q=$url"
fi
