#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Wallpapers"

TRANSITION_TYPE="grow"
TRANSITION_POS="center"
TRANSITION_DURATION="1.5"

# Start swww if needed
if ! swww query >/dev/null 2>&1; then
    swww init
    sleep 0.3
fi

# Read wallpapers safely
mapfile -d '' WALLPAPERS < <(
    find "$WALLPAPER_DIR" -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \
    \) -print0 | sort -z
)

# No wallpapers found
if [ "${#WALLPAPERS[@]}" -eq 0 ]; then
    echo "No wallpapers found" | rofi -dmenu -p "Error"
    exit 1
fi

# Build menu
MENU=("Random")
for wp in "${WALLPAPERS[@]}"; do
    MENU+=("$(basename "$wp")")
done

# Rofi selection (returns index)
SELECTED_INDEX=$(printf '%s\n' "${MENU[@]}" \
    | rofi -dmenu -i -p "Wallpaper" -format i)

# Cancelled
[ -z "$SELECTED_INDEX" ] && exit 0

# Choose wallpaper
if [ "$SELECTED_INDEX" -eq 0 ]; then
    WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
else
    WALLPAPER="${WALLPAPERS[SELECTED_INDEX-1]}"
fi

# Set wallpaper
swww img "$WALLPAPER" \
    --transition-type "$TRANSITION_TYPE" \
    --transition-pos "$TRANSITION_POS" \
    --transition-duration "$TRANSITION_DURATION"
