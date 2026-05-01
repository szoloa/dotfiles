function mv2music
    set folder (ls $HOME/Musics | fzf)
    if test (count $argv) -eq 0
        echo "please give args."
    else
        mv $argv "$HOME/Musics/$folder"
    end
end
