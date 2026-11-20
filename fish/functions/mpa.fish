function mpa
    if test -z $argv
        echo "please give args."
    else
        # mpvpaper HDMI-A-1 -o loop $argv
        mpvpaper -o loop eDP-1 $argv
    end
end
