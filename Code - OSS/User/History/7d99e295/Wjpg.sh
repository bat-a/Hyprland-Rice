#!/bin/bash
if [ "$1" = "dark" ]; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    sed -i 's/color_scheme_path=.*"/color_scheme_path="\/usr\/share\/color-schemes\/BreezeDark.colors"/' ~/.config/qt6ct/qt6ct.conf
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
    sed -i 's/color_scheme_path=.*"/color_scheme_path="\/usr\/share\/color-schemes\/BreezeLight.colors"/' ~/.config/qt6ct/qt6ct.conf
fi
hyprctl reload
notify-send "Theme switched to $1"
