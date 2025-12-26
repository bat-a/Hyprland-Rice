switch_theme() {
    local mode="$1"
    local kde_scheme="BreezeDark"  # or BreezeLight
    [[ "$mode" == "light" ]] && kde_scheme="BreezeLight"
    
    # GTK
    gsettings set org.gnome.desktop.interface color-scheme "prefer-$mode"
    
    # KDE globals (Dolphin priority)
    cat > ~/.config/kdeglobals << EOF
[Colors:Window]
BackgroundNormal=$( [[ "$mode" == "dark" ]] && echo "1e1e2e" || echo "f8f9fa" )
BackgroundAlternate=$( [[ "$mode" == "dark" ]] && echo "2d2d30" || echo "e9ecef" )
ForegroundNormal=$( [[ "$mode" == "dark" ]] && echo "cdd6f4" || echo "212529" )

[Colors:View]
BackgroundNormal=$( [[ "$mode" == "dark" ]] && echo "1e1e2e" || echo "ffffff" )
ForegroundNormal=$( [[ "$mode" == "dark" ]] && echo "cdd6f4" || echo "212529" )

[General]
ColorScheme=$kde_scheme
EOF
    
    # Qt6ct fallback
    sed -i "s|^color_scheme_path=.*\"|color_scheme_path=\"/usr/share/color-schemes/${kde_scheme}.colors\"|" "$QT6CT_CONF" 2>/dev/null || true
    
    # FULL Dolphin restart (required)
    pkill -x dolphin || true
    sleep 0.5
    dolphin &>/dev/null &
    
    hyprctl reload
    notify-send "Theme" "Switched to $mode (Dolphin restarted)"
}
