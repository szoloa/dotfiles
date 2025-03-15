function xhs
    if test -z $argv
        google-chrome-stable --app=https://www.xiaohongshu.com
    else
        echo $argv | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g' | xargs -i google-chrome-stable --app=https://www.xiaohongshu.com/search_result\?keyword={}
    end
end
