#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Configuration
# ----------------------------
WALLPAPER_DIR="$HOME/Wallpapers"
INTERVAL=300   # 5 minutes

# Smooth fade settings
TRANSITION_TYPE="fade"
TRANSITION_DURATION="1.5"
TRANSITION_BEZIER=".4,0,.2,1"

# ----------------------------
# Start swww if not running
# ----------------------------
if ! swww query >/dev/null 2>&1; then
    swww init
    sleep 0.3
fi

# ----------------------------
# Read wallpapers safely
# ----------------------------
mapfile -d '' WALLPAPERS < <(
    find "$WALLPAPER_DIR" -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \
    \) -print0 | sort -z
)

[ "${#WALLPAPERS[@]}" -eq 0 ] && exit 1

# ----------------------------
# Wallpaper setter function
# ----------------------------
set_wallpaper() {
    local wp="$1"
    swww img "$wp" \
        --transition-type "$TRANSITION_TYPE" \
        --transition-duration "$TRANSITION_DURATION" \
        --transition-bezier "$TRANSITION_BEZIER"
}

# ----------------------------
# Automatic mode
# ----------------------------
if [[ "${1:-}" == "--auto" ]]; then
    while true; do
        WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
        set_wallpaper "$WALLPAPER"
        sleep "$INTERVAL"
    done
fi

# ----------------------------
# Manual mode (Rofi)
# ----------------------------
MENU=("Random")
for wp in "${WALLPAPERS[@]}"; do
    MENU+=("$(basename "$wp")")
done

SELECTED_INDEX=$(printf '%s\n' "${MENU[@]}" \
    | rofi -dmenu -i -p "Wallpaper" -format i)

[ -z "$SELECTED_INDEX" ] && exit 0

if [ "$SELECTED_INDEX" -eq 0 ]; then
    WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
else
    WALLPAPER="${WALLPAPERS[SELECTED_INDEX-1]}"
fi

set_wallpaper "$WALLPAPER"
