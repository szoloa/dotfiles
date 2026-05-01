function cppath 
    if test (count $argv) -eq 0
        echo "please give args."
    else
        echo "$PWD/$argv"
    end
end
