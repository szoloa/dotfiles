function vfg
    set tmp (find ~/.config ~/temp/dotfiles/arch -type f -size -30k | fzf --preview='cat {}')
    if not test -z $tmp
        nvim $tmp
    end
end
