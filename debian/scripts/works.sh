#!/usr/bin/bash

endtime=$(date -d +25minutes +"%Y-%m-%d %H:%M:%S")
echo $endtime > ~/.config/i3blocks/scripts/countDown
