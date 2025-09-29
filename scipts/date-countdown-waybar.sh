#!/bin/bash

x=$(date -d "Dec 20" +%j)

y=$(date +%j)

count=$(echo $x-$y | bc)

if [ $count -eq 0 ];then
    echo "TODAY"
else
    echo DAYS $count
fi
