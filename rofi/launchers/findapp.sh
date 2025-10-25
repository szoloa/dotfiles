#!/usr/bin/env bash
#
## Author : Pavel Sibal
## Rofi   : Findapp
#

theme='FindApp-01.rasi'
icon_theme='WhiteSur-light'

## Run
rofi \
     -show drun \
     -icon-theme ${icon_theme} \
     -font 'San Francisco Display Regular 11' \
     -theme ${theme}
