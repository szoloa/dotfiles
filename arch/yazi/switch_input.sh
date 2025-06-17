#!/bin/bash

if [ "$1" == "zh" ]; then
    fcitx5-remote -o  # 切换到中文输入法
elif [ "$1" == "en" ]; then
    fcitx5-remote -c  # 切换到英文输入法
fi

