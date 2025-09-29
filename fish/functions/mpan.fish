function mpan
    if test -z $argv
        echo "please give args."
    else
        mpvpaper HDMI-A-1 -o "loop no-audio" $argv
    end
end
