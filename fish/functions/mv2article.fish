function mv2article
    if test (count $argv) -eq 0
        echo "please give args."
    else
        mv $argv "$HOME/Documents/article/"
    end
end
