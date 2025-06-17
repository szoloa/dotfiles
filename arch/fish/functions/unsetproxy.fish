function unsetproxy 
	set -e http_proxy; 
	set -e https_proxy; 
	set -e all_proxy; 
	echo 'Unset proxy successfully';  
end
