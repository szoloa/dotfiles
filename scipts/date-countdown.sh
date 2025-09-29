#!/bin/bash

x=$(date -d "Dec 20" +%j)

y=$(date +%j)

count=$(echo $x-$y | bc)

if [ $count -eq 0 ];then
    echo "Today"
else
    echo 距离考研：$count 天
fi
