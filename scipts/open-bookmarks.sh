#!/bin/sh

url=$(cat ~/Documents/bookmarks | wmenu -p "Website " -f "Hack 12" -l 4)

if [[ -z url ]];then
    echo "please select a url."
else
    xdg-open $url
fi
