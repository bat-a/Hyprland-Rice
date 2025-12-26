#!/usr/bin/env bash

# theme_switcher.sh - Robust Hyprland theme switcher with app reload
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
QT6CT_CONF="${HOME}/.config/qt6ct/qt6ct.conf"
DARK_SCHEME="/usr/share/color-schemes/BreezeDark.colors"
LIGHT_SCHEME="/usr/share/color-schemes/BreezeLight.colors"
LOG_FILE="${SCRIPT_DIR}/theme_switcher.log"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

check_deps() {
    local missing=()
    command -v gsettings >/dev/null || missing+=("gsettings")
    command -v notify-send >/dev/null || missing+=("notify-send")
    [[ -f "$QT6CT_CONF" ]] || log "Warning: $QT6CT_CONF not found"
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        notify-send "Error" "Missing: ${missing[*]}" 2>/dev/null || \
        log "ERROR: Missing commands: ${missing[*]}"
        exit 1
    fi
}

switch_theme() {
    local mode="$1"
    local color_scheme="$2"
    
    log "Switching to $mode theme..."
    
    # GTK theme
    gsettings set org.gnome.desktop.interface color-scheme "prefer-$mode"
    log "GTK: Set to prefer-$mode"
    
    # Qt6 theme
    if [[ -f "$QT6CT_CONF" ]]; then
        if sed -i "s|^color_scheme_path=.*\"|color_scheme_path=\"$color_scheme\"|" "$QT6CT_CONF" 2>/dev/null; then
            log "Qt6: Updated $QT6CT_CONF"
        else
            log "Warning: Failed to update qt6ct.conf"
        fi
    fi
    
    # Core reload
    hyprctl reload
    log "Hyprland: Reloaded config"
    
    # Reload GTK apps
    pkill -USR1 -x nautilus 2>/dev/null || true
    pkill -USR1 -x gnome-files 2>/dev/null || true
    lxappearance -i 2>/dev/null || true
    log "GTK: Sent reload signals"
    
    # Reload Plasma/KDE (if running)
    kquitapp6 plasmashell && sleep 1 && kstart6 plasmashell 2>/dev/null || true
    qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.reconfigure 2>/dev/null || true
    log "KDE: Restarted plasmashell"
    
    # Reload bars & UI
    pkill -USR1 waybar 2>/dev/null || true
    pkill -USR1 swaybar 2>/dev/null || true
    log "Bars: Reloaded"
    
    # Reload Dolphin & Qt apps
    pkill -USR1 dolphin 2>/dev/null || true
    pkill -USR1 -f "qt6ct" 2>/dev/null || true
    log "Qt: Reloaded Dolphin"
    
    log "Successfully switched to $mode theme"
    notify-send "Theme" "Switched to $mode (apps reloaded)" || log "notify-send failed"
}

case "${1:-}" in
    "dark"|"d")
        check_deps
        switch_theme "dark" "$DARK_SCHEME"
        ;;
    "light"|"l")
        check_deps
        switch_theme "light" "$LIGHT_SCHEME"
        ;;
    "toggle"|"t")
        check_deps
        if gsettings get org.gnome.desktop.interface color-scheme | grep -q "prefer-dark"; then
            switch_theme "light" "$LIGHT_SCHEME"
        else
            switch_theme "dark" "$DARK_SCHEME"
        fi
        ;;
    "status"|"s")
        local current=$(gsettings get org.gnome.desktop.interface color-scheme | sed "s/'//g")
        notify-send "Current theme" "$current"
        echo "Current: $current"
        ;;
    *)
        echo "Usage: $0 {dark|d|light|l|toggle|t|status|s}"
        echo "  dark/d    -> Dark theme"
        echo "  light/l   -> Light theme" 
        echo "  toggle/t  -> Toggle current"
        echo "  status/s  -> Show current"
        exit 1
esac
