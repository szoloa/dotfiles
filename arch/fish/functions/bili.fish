function bili
    if test -z $argv
        google-chrome-stable --app=https://www.bilibili.com
    else
        echo $argv | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g' | xargs -i google-chrome-stable --app=https://www.bilibili.com/search\?keyword={}
    end
end
