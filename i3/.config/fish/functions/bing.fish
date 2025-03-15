function bing
	if test -z $argv;
		google-chrome-stable --app=https://bing.com
	else;
		echo $argv | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g' | xargs -i google-chrome-stable --app=https://bing.com/search\?q={}
	end
end
