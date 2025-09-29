#!/usr/bin/bash
function fish_sink
	pactl set-default-sink $(pactl list sinks short | fzf | awk '{print $1}')
end
