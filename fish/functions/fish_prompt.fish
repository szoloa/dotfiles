function fish_prompt
        set_color brblue
        echo -n (path basename $PWD)
        set_color brgreen
        echo -n ' > '
        set_color brwhite
end
