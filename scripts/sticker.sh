#!/usr/bin/bash 

set -euo pipefail

STICKER_DIR="$HOME/Pictures/Sticker/"
ROFI_CONFIG="$HOME/.config/rofi/launchers/Launchpad-Sticker.rasi"
SYMLINK_PATH="$HOME/.config/hypr/current_wallpaper"
IMAGE_EXTENSIONS=("jpg", "jpeg", "png", "webp", "gif")

is_image() {
    local f=$1
    for ext in "${IMAGE_EXTENSIONS[@]}"; do
        [[ "${f,,}" == *.$ext ]] && return 0
    done
    return 1
}

cd "$STICKER_DIR" || exit 1

SELECTED_WALL="$({ find "$STICKER_DIR" -maxdepth 1 -type f \
    | grep -Ei '\.(jpg|jpeg|png|webp|gif)$' \
    | sort -r \
    | while read -r img; do 
        printf "%s\0icon\x1f%s\n" "$(basename "$img")" "$img"
    done
} | rofi -dmenu -i -show-icons -config "$ROFI_CONFIG")"

[[ -z "$SELECTED_WALL" ]] && exit 0 

SELECTED_WALL="$STICKER_DIR/$SELECTED_WALL"

wl-copy < "$SELECTED_WALL"
