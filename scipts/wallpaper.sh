#/usr/bin/bash

if pgrep -x swaybg >/dev/null; then
  killall -e swaybg
fi

swaybg -i $1 &
