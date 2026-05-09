#!/usr/bin/bash 

set -euo pipefail

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
ROFI_CONFIG="$HOME/.config/rofi/launchers/Launchpad-Wallpaper.rasi"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
IMAGE_EXTENSIONS=("jpg", "jpeg", "png", "webp")

is_image() {
    local f=$1
    for ext in "${IMAGE_EXTENSIONS[@]}"; do
        [[ "${f,,}" == *.$ext ]] && return 0
    done
    return 1
}

pick_random_wallpaper() {
    find "$WALLPAPER_DIR" -maxdepth 1 type f | grep -Ei '\.(jpg|jpeg|png|webp)' | shuf -n 1
}

cd "$WALLPAPER_DIR" || exit 1

SELECTED_WALL="$({ find "$WALLPAPER_DIR" -maxdepth 1 -type f \
    | grep -Ei '\.(jpg|jpeg|png|webp)$' \
    | sort -r \
    | while read -r img; do 
        printf "%s\0icon\x1f%s\n" "$(basename "$img")" "$img"
    done
} | rofi -dmenu -i -show-icons -config "$ROFI_CONFIG")"

[[ -z "$SELECTED_WALL" ]] && exit 0 

SELECTED_WALL="$WALLPAPER_DIR/$SELECTED_WALL"

ln -sf "$SELECTED_WALL" "$SYMLINK_PATH" 

pkill hyprpaper 2>/dev/null || true 

sleep 0.2
hyprpaper & 
