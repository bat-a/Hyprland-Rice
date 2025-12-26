#!/bin/bash

# Directory containing your wallpapers
WALLPAPER_DIR="$HOME/wallpapers"

# Find all image files (adjust extensions if needed)
WALLPAPERS=$(find "$WALLPAPER_DIR" -type f \( -iname \*.jpg -o -iname \*.png -o -iname \*.jpeg \))

# If there are wallpapers, show the menu with rofi
if [ -n "$WALLPAPERS" ]; then
    # Create a list for rofi
    SELECTED_WALLPAPER=$(echo "$WALLPAPERS" | rofi -dmenu -i -p "Select a wallpaper:")

    # If the user selected a wallpaper
    if [ -n "$SELECTED_WALLPAPER" ]; then
        feh --bg-fill "$SELECTED_WALLPAPER"
        echo "Wallpaper set to $SELECTED_WALLPAPER"
    else
        # If user presses ESC or cancels the menu, set a random wallpaper
        RANDOM_WALLPAPER=$(echo "$WALLPAPERS" | shuf -n 1)
        feh --bg-fill "$RANDOM_WALLPAPER"
        echo "Random wallpaper set."
    fi
else
    echo "No wallpapers found in $WALLPAPER_DIR"
fi
