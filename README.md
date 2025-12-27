# 🌌 Hyprland-Rice

<p align="center">
  <img src="./Wallpapers/preview.png" alt="Hyprland Rice Preview" width="600px">
</p>

A **clean and personal Hyprland rice** — dotfiles and configs for a simple Wayland setup using **Hyprland**, **Waybar**, **Kitty**, and **Rofi**.

This repository contains **only configuration files**.  
There is **no install script** — users manually clone and apply what they want.

---



## 🚀 What’s Inside

| Folder | What it contains |
|--------|-----------------|
| `hypr/` | Hyprland config files (keybinds, workspaces, autostart) |
| `waybar/` | Waybar bar configuration |
| `kitty/` | Kitty terminal config |
| `rofi/` | Rofi launcher themes & configs |
| `Wallpapers/` | Wallpapers included in this rice |

---

## 📦 Requirements

Before using this rice, make sure you have installed:

- **Hyprland** — Wayland compositor  
- **Waybar** — status bar  
- **Kitty** — terminal emulator  
- **Rofi** — application launcher  
- **Nerd Fonts** — for icons  

Example on Arch Linux:

```bash
sudo pacman -S hyprland waybar kitty rofi nerd-fonts-complete
```

## 📁 Clone & Apply (User Guide)

Follow these steps to safely apply the rice to your system:

## 1️⃣ Clone the repository
```bash
git clone https://github.com/bat-a/Hyprland-Rice.git
cd Hyprland-Rice
```

## 2️⃣ Backup your existing configs
```bash
mkdir -p ~/.config/backup-hyprland-rice
cp -r ~/.config/hypr ~/.config/waybar ~/.config/kitty ~/.config/rofi ~/.config/backup-hyprland-rice/
```

💡 This ensures you can restore your old setup if anything goes wrong.

## 3️⃣ Copy the rice configs to your system
```bash
cp -r hypr ~/.config/
cp -r waybar ~/.config/
cp -r kitty ~/.config/
cp -r rofi ~/.config/
```

⚠️ Tip: You can copy only the folders you want to overwrite.

## 4️⃣ Apply wallpapers
```bash
mkdir -p ~/Pictures/Wallpapers
cp -r Wallpapers/* ~/Pictures/Wallpapers/
```
## 5️⃣ Reload Hyprland

Either log out and log back in, or

Use your reload keybind (if set) to apply new configs.

🎉 Your new rice is now active!

## 🧠 Customize It

Edit colors, fonts, and icons directly in config files.

Modify Rofi in rofi/config.rasi

Add or remove Waybar modules to match your workflow.


## this is first time rice by ME.. that's it use as own risk.....
