function bing
	if test -z $argv;
		firefox https://bing.com
	else;
		echo $argv | tr -d '\n' | xxd -plain | sed 's/\(..\)/%\1/g' | xargs -i  firefox https://bing.com/search\?q={}
	end
end
