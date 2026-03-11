#!/usr/bin/bash

# Use wmenu and kd to give quick access 
# of dict.
# recommand to bind with a specical key.
# Such as: bindsym $mod+w exec "/path/to/dict.sh"
export SDCV_PAGER="less -R"

word=$(: | wmenu -p "Dict " -f "JetBrains Mono 14")
rtrn=$?
[ "$rtrn" -ne 0 ] && exit $rtrn

if [[ $word == "" ]]; then 
    word=$(wl-paste)
fi 

trans=$(sdcv -n --color --utf8-output $word)

if [[ trans == "Not found"* ]]; then
  notify-send "not found"
else
    kitty --app-id="kitty-float" sdcv --color --utf8-output $word
fi
