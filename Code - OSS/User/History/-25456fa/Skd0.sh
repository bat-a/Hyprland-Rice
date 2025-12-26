#!/bin/bash

WALLPAPER_DIR="$HOME/Wallpapers"

# Start swww if not running
if ! pgrep -x swww-daemon > /dev/null; then
    swww init
    sleep 0.5
fi

# Get list of wallpapers
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( \
    -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \
\))

# Exit if no wallpapers
[ -z "$WALLPAPERS" ] && exit 1

# Build menu (only filenames shown)
MENU=$(echo "$WALLPAPERS" | xargs -n1 basename)

# Rofi menu
SELECTED=$(echo -e "Random\n$MENU" | rofi -dmenu -i -p "Wallpaper")

# Random wallpaper
if [ "$SELECTED" = "Random" ] || [ -z "$SELECTED" ]; then
    WALLPAPER=$(echo "$WALLPAPERS" | shuf -n 1)
else
    WALLPAPER=$(echo "$WALLPAPERS" | grep "/$SELECTED$")
fi

# Set wallpaper with swww
swww img "$WALLPAPER" \
    --transition-type any \
    --transition-pos any \
    --transition-duration 1.5
