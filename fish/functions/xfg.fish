function xfg
    set tmp (ls | fzf)
    if not test -z $tmp
        xdg-open $tmp
    end
end
