#!/usr/bin/env bash
set -euo pipefail

WALLPAPER_DIR="$HOME/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-thumbs"
mkdir -p "$CACHE_DIR"

# ---- swww transition ----
TRANSITION_TYPE="grow"
TRANSITION_POS="center"
TRANSITION_DURATION="1.5"

# ---- Start swww ----
if ! swww query >/dev/null 2>&1; then
    swww init
    sleep 0.3
fi

# ---- Collect wallpapers safely ----
mapfile -d '' WALLPAPERS < <(
    find "$WALLPAPER_DIR" -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.webp' \
    \) -print0
)

[ "${#WALLPAPERS[@]}" -eq 0 ] && exit 1

# ---- Generate thumbnails (cached) ----
MENU=("Random")
ICONS=("")

for wp in "${WALLPAPERS[@]}"; do
    name="$(basename "$wp")"
    hash="$(printf '%s' "$wp" | sha1sum | cut -d' ' -f1)"
    thumb="$CACHE_DIR/$hash.png"

    if [ ! -f "$thumb" ]; then
        magick "$wp" -resize 256x256^ -gravity center -extent 256x256 "$thumb"
    fi

    MENU+=("$name")
    ICONS+=("$thumb")
done

# ---- Build rofi input ----
ROFI_INPUT=""
for i in "${!MENU[@]}"; do
    ROFI_INPUT+="${MENU[$i]}\0icon\x1f${ICONS[$i]}\n"
done

# ---- Rofi (icon mode) ----
SELECTED_INDEX=$(printf '%b' "$ROFI_INPUT" | \
    rofi -dmenu -i -p "Wallpaper" \
    -show-icons -format i)

[ -z "$SELECTED_INDEX" ] && exit 0

# ---- Pick wallpaper ----
if [ "$SELECTED_INDEX" -eq 0 ]; then
    WALLPAPER="${WALLPAPERS[RANDOM % ${#WALLPAPERS[@]}]}"
else
    WALLPAPER="${WALLPAPERS[SELECTED_INDEX-1]}"
fi

# ---- Set per-monitor wallpaper ----
while read -r output _; do
    swww img "$WALLPAPER" \
        --outputs "$output" \
        --transition-type "$TRANSITION_TYPE" \
        --transition-pos "$TRANSITION_POS" \
        --transition-duration "$TRANSITION_DURATION"
done < <(swww query | awk '/^output/ {print $2}')

# ---- Generate colorscheme ----
if command -v wallust >/dev/null 2>&1; then
    wallust run "$WALLPAPER"
elif command -v wal >/dev/null 2>&1; then
    wal -i "$WALLPAPER" -n
fi

# ---- Reload apps ----
# Waybar
pkill -SIGUSR2 waybar 2>/dev/null || true

# Hyprland
hyprctl reload >/dev/null 2>&1 || true

# Kitty
pkill -USR1 kitty 2>/dev/null || true

# Neovim (reload colors via pywal/wallust)
for sock in /tmp/nvim*/0; do
    nvim --server "$sock" --remote-send ':colorscheme wal<CR>' 2>/dev/null || true
done
