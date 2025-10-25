#!/usr/bin/fish
function fish_network
    nmcli networking on
    nmcli connection up $(nmcli connection | grep wifi | fzf | awk '{print $1}')
end
