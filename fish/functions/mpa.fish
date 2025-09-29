function mpa
    if test -z $argv
        echo "please give args."
    else
        mpvpaper HDMI-A-1 -o loop $argv
    end
end
