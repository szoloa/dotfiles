function tl
    if test -z $argv
        echo "Not found :("
    else
        trans -proxy localhost:7890 -t zh -b $argv
    end
end
