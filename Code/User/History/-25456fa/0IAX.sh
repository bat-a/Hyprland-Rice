#!/usr/bin/env bash
set -euo pipefail

# ----------------------------
# Configuration
# ----------------------------
WALLPAPER_DIR="${WALLPAPER_DIR:-$HOME/Wallpapers}"
INTERVAL=300   # 5 minutes

# List of possible transitions
TRANSITIONS=("fade" "grow" "slide-left" "slide-right" "slide-up" "slide-down" "zoom")

# Fade settings (only used if fade chosen)
TRANSITION_DURATION=1.5
TRANSITION_BEZIER=".4,0,.2,1"

# ----------------------------
# Check if swww is installed
# ----------------------------
if ! command -v swww &>/dev/null; then
    echo "Error: 'swww' is not installed. Exiting."
    exit 1
fi

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
    \) -print0 | sort -zu
)

if [ "${#WALLPAPERS[@]}" -eq 0 ]; then
    echo "Error: No wallpapers found in '$WALLPAPER_DIR'. Exiting."
    exit 1
fi

# ----------------------------
# Wallpaper setter function
# ----------------------------
set_wallpaper() {
    local wp="$1"
    local transition="${TRANSITIONS[RANDOM % ${#TRANSITIONS[@]}]}"
    
    echo "Setting wallpaper: $wp with transition: $transition"
    
    if [ "$transition" = "fade" ]; then
        swww img "$wp" \
            --transition-type "$transition" \
            --transition-duration "$TRANSITION_DURATION" \
            --transition-bezier "$TRANSITION_BEZIER" \
            || { echo "Failed to set wallpaper: $wp"; exit 1; }
    else
        swww img "$wp" \
            --transition-type "$transition" \
            --transition-duration "$TRANSITION_DURATION" \
            || { echo "Failed to set wallpaper: $wp"; exit 1; }
    fi
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
# Manual mode (Rofi) with collision-free menu
# ----------------------------
declare -A WP_MAP
MENU=("Random")
for wp in "${WALLPAPERS[@]}"; do
    name="$(basename "$wp")"
    # Handle duplicates by using a timestamp-based suffix
    if [[ -n "${WP_MAP[$name]:-}" ]]; then
        name="$name-$(date +%s%N)"
    fi
    WP_MAP["$name"]="$wp"
    MENU+=("$name")
done

SELECTED=$(printf '%s\n' "${MENU[@]}" | rofi -dmenu -i -p "Wallpaper")
[ -z "$SELECTED" ] && exit 0

if [ "$SELECTED" = "Random" ]; then
    WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
else
    WALLPAPER="${WP_MAP[$SELECTED]}"
fi

set_wallpaper "$WALLPAPER"
