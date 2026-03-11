function vfo
    set tmp (find ~/Documents/obsidian -type f | grep .md | fzf --preview='cat {}')
    if not test -z $tmp
        nvim $tmp
    end
end
