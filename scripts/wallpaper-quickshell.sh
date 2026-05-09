#!/usr/bin/bash 

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
IMAGE_EXTENSIONS=("jpg", "jpeg", "png", "webp")

SELECTED_WALL=$1

ln -sf "$SELECTED_WALL" "$SYMLINK_PATH" 

pkill hyprpaper 2>/dev/null || true 

sleep 0.2
hyprpaper & 
