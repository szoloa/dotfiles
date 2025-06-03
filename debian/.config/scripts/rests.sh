#!/usr/bin/bash

endtime=$(date -d +5minutes +"%Y-%m-%d %H:%M:%S")
echo $endtime > ~/.config/i3blocks/scripts/countDown
