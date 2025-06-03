#!/usr/bin/bash

url=$(cat ~/Documents/bookmark/bookmark.txt | rofi -dmenu -p "url ") rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $url == http*://* ]]; then
  firefox "$url"
else
  firefox "https://bing.com/search?q=$url"
fi
