function xfg
    set tmp (find * -type f | fzf)
    if not test -z $tmp
        xdg-open $tmp
    end
end
