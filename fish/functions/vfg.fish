function vfg
    set tmp (find ~/.config -type f -size -30k | fzf --preview='cat {}')
    if not test -z $tmp
        vim $tmp
    end
end
