#!/usr/bin/fish

set lst (cat ~/temp/randomVedio/mygo.txt)

set url (random choice $lst)

qutebrowser $(echo $url | awk '{print $NF}')
