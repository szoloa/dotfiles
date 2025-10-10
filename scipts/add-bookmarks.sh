#!/bin/bash

# add bookmarks to Documents/bookmarks.
# Simple: bash add-bookmarks.sh https://wikipedia.org/
#

if [[ -n $1 ]];then
    echo $1 >> ~/Documents/bookmarks
    echo "Success!"
else
    echo "please give a argument."
fi
