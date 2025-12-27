#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Configuration
# ----------------------------
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Wallpapers}"
# Check if the wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Error: Wallpaper directory '$WALLPAPER_DIR' does not exist."
    exit 1
fi

# ----------------------------
# Select a random wallpaper
# ----------------------------
WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \) | shuf -n 1)

if [ -z "$WALLPAPER" ]; then
    echo "Error: No wallpapers found in '$WALLPAPER_DIR'."
    exit 1
fi

echo "Selected wallpaper: $WALLPAPER"

# ----------------------------
# Set the wallpaper using swww with transition
# ----------------------------
# You can customize the transition and duration if desired
swww img "$WALLPAPER" --transition-type "fade" --transition-duration 1.5
