#!/usr/bin/bash
export DISPLAY=:0
export DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/$(id -u)/bus
/usr/local/bin/qwen 现在是$(TZ='Asia/Shanghai' date +%H:%M)，告诉我当前时间并提醒我休息 | xargs -i notify-send 注意休息～ {}

