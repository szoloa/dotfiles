#!/bin/bash

# 使用 slop 获取框选区域的坐标和尺寸
read -r X Y W H < <(slop -f "%x %y %w %h")

# 将当前窗口设为浮动模式（若未处于浮动状态）
i3-msg "floating enable"

# 移动窗口到框选区域的左上角坐标
i3-msg "move position $X $Y"

# 调整窗口大小以匹配框选区域的宽高
i3-msg "resize set $W $H"
