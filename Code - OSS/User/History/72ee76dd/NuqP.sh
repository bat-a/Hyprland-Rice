#!/bin/bash

# Function to detect the distribution
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        DISTRO=$NAME
        VERSION=$VERSION_ID
    elif [ -f /etc/lsb-release ]; then
        . /etc/lsb-release
        DISTRO=$DISTRIB_ID
        VERSION=$DISTRIB_RELEASE
    else
        DISTRO="Unknown"
        VERSION="Unknown"
    fi
}

# Run the distro detection
detect_distro
echo "Detected distribution: $DISTRO $VERSION"

# Function to install dependencies based on the detected distro
install_dependencies() {
    case $DISTRO in
        "Ubuntu"|"Debian")
            echo "Installing dependencies using apt (Debian/Ubuntu)..."
            sudo apt update || { echo "Failed to update package list. Exiting."; exit 1; }
            sudo apt install -y \
                hyprland \
                waybar \
                rofi \
                kitty \
                vivaldi-stable \
                code-oss \
                curl \
                git \
                neovim \
                fontconfig \
                python3-pip \
                ripgrep \
                dunst \
                lxappearance \
                light \
                lm-sensors \
                xclip \
                swaylock \
                swayidle \
                sxhkd \
                wayland-utils \
                weston || { echo "Failed to install dependencies. Exiting."; exit 1; }
            ;;
        "Fedora")
            echo "Installing dependencies using dnf (Fedora)..."
            sudo dnf install -y \
                hyprland \
                waybar \
                rofi \
                kitty \
                vivaldi-stable \
                code-oss \
                curl \
                git \
                neovim \
                fontconfig \
                python3-pip \
                ripgrep \
                dunst \
                lxappearance \
                light \
                lm-sensors \
                xclip \
                swaylock \
                swayidle \
                sxhkd \
                wayland-utils \
                weston || { echo "Failed to install dependencies. Exiting."; exit 1; }
            ;;
        "Arch Linux"|"Manjaro")
            echo "Installing dependencies using pacman (Arch/Manjaro)..."
            sudo pacman -Syu --noconfirm \
                hyprland \
                waybar \
                rofi \
                kitty \
                vivaldi \
                curl \
                git \
                neovim \
                fontconfig \
                python-pip \
                ripgrep \
                dunst \
                lxappearance \
                swaylock \
                swayidle \
                sxhkd \
                wayland-utils \
                weston \
                lm_sensors || { echo "Failed to install core dependencies. Exiting."; exit 1; }

            # Install visual-studio-code-bin (correct package for code-oss)
            echo "Installing Visual Studio Code..."
            yay -S --noconfirm visual-studio-code-bin || { echo "Failed to install Visual Studio Code. Exiting."; exit 1; }

            # Install light (from AUR)
            echo "Installing light (from AUR)..."
            yay -S --noconfirm light || { echo "Failed to install light. Exiting."; exit 1; }
            ;;
        *)
            echo "Unsupported distribution: $DISTRO. This script supports Ubuntu/Debian, Fedora, and Arch."
            exit 1
            ;;
    esac
}

# Install the dependencies based on detected distro
install_dependencies

# Install fonts (JetBrains Mono, Hack, Roboto, Awesome)
echo "Installing fonts..."
mkdir -p ~/.local/share/fonts

# JetBrains Mono
curl -L https://github.com/JetBrains/JetBrainsMono/releases/download/2.238/JetBrainsMono-2.238.zip -o ~/JetBrainsMono.zip
unzip -o ~/JetBrainsMono.zip -d ~/.local/share/fonts/ || { echo "Failed to install JetBrains Mono. Exiting."; exit 1; }

# Hack Font (Nerd Fonts)
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip -o ~/Hack.zip
unzip -o ~/Hack.zip -d ~/.local/share/fonts/ || { echo "Failed to install Hack font. Exiting."; exit 1; }

# Awesome Font (Nerd Fonts)
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip -o ~/UbuntuMono.zip
unzip -o ~/UbuntuMono.zip -d ~/.local/share/fonts/ || { echo "Failed to install Awesome font. Exiting."; exit 1; }

# Roboto Font (Google Fonts)
curl -L https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Regular.ttf -o ~/.local/share/fonts/Roboto-Regular.ttf
curl -L https://github.com/google/fonts/raw/main/apache/roboto/Roboto-Bold.ttf -o ~/.local/share/fonts/Roboto-Bold.ttf
fc-cache -fv || { echo "Failed to install Roboto font. Exiting."; exit 1; }

# Font cache update
echo "Rebuilding font cache..."
fc-cache -fv || { echo "Failed to rebuild font cache. Exiting."; exit 1; }

# Clone Hyprland rice repository
echo "Cloning Hyprland Rice repository..."
git clone https://github.com/bat-a/Hyprland-Rice.git ~/.config/hyprland || { echo "Failed to clone repository. Exiting."; exit 1; }

# Copy configuration files from the repository to the correct locations
echo "Copying configuration files..."
cp -r ~/.config/hyprland/* ~/.config/ || { echo "Failed to copy Hyprland configuration files. Exiting."; exit 1; }

# Ensure all scripts in the rice folder are executable
echo "Making configuration files executable..."
chmod +x ~/.config/hyprland/* || { echo "Failed to make scripts executable. Exiting."; exit 1; }

# Check if keybinding manager (sxhkd) is set up
if ! pgrep -x "sxhkd" > /dev/null; then
    echo "sxhkd is not running. Starting sxhkd..."
    sxhkd & || { echo "Failed to start sxhkd. Exiting."; exit 1; }
fi

echo "Hyprland Rice setup completed successfully!"

# Final instructions
echo "Setup complete. To apply changes, you may need to restart your session or reboot your system."

# Reboot prompt
read -p "Would you like to reboot your system now? (y/n): " choice
if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
    echo "Rebooting the system..."
    sudo reboot
else
    echo "You can reboot your system later to apply the changes."
fi
