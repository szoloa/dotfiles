function fish_prompt
        set_color brblue
        echo -n (path basename $PWD)
        set_color cyan
        echo -n ' > '
        # echo -n ' do '
        set_color brwhite
end
