#!/usr/bin/bash

url=$(cat ~/Documents/bookmark/bookmark.txt | rofi -dmenu -p "url ") rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $url == https://* ]]; then
  google-chrome-stable "$url"
else
  google-chrome-stable "https://google.com/search?q=$url"
fi
