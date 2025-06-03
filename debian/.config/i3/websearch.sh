#!/usr/bin/bash

url=$(: | rofi -dmenu -p "url ") rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $url == https://* ]]; then
  chromium --class="chrome-floating" --new-window "$url"
else
  chromium --class="chrome-floating" --new-window "https://bing.com/search?q=$url"
fi
