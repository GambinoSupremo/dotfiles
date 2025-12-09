#!/bin/bash

# Gavin's CachyOS Setup Script
# Run after fresh CachyOS Hyprland install

set -e

echo "=== Gavin's Setup Script ==="

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${GREEN}==>${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}==>${NC} $1"
}

# Update system first
print_status "Updating system..."
sudo pacman -Syu --noconfirm

# Install yay if not present
if ! command -v yay &> /dev/null; then
    print_status "Installing yay..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay && makepkg -si --noconfirm
    cd -
fi

# Shell & Terminal
print_status "Installing shell & terminal packages..."
sudo pacman -S --needed --noconfirm \
    ghostty \
    zsh \
    starship \
    zoxide \
    fzf \
    eza \
    bat \
    ripgrep \
    fd

# File Management
print_status "Installing file management packages..."
sudo pacman -S --needed --noconfirm \
    nautilus \
    unzip \
    unrar \
    p7zip

# Hyprland & Desktop
print_status "Installing Hyprland & desktop packages..."
sudo pacman -S --needed --noconfirm \
    waybar \
    rofi-wayland \
    mako \
    hypridle \
    hyprlock \
    hyprpicker \
    hyprsunset \
    swaybg \
    wl-clipboard \
    polkit-gnome \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk

# Screenshots & Recording
print_status "Installing screenshot & recording packages..."
sudo pacman -S --needed --noconfirm \
    grim \
    slurp \
    satty \
    obs-studio

# Audio & Media
print_status "Installing audio & media packages..."
sudo pacman -S --needed --noconfirm \
    pamixer \
    playerctl \
    pavucontrol \
    mpv

# Music & Entertainment
print_status "Installing music & entertainment packages..."
sudo pacman -S --needed --noconfirm \
    steam \
    protonup-qt

# Productivity
print_status "Installing productivity packages..."
sudo pacman -S --needed --noconfirm \
    obsidian

# Development
print_status "Installing development packages..."
sudo pacman -S --needed --noconfirm \
    git \
    github-cli \
    neovim \
    docker \
    docker-compose

# System Utilities
print_status "Installing system utilities..."
sudo pacman -S --needed --noconfirm \
    btop \
    fastfetch \
    brightnessctl \
    upower \
    man-db \
    tldr

# Networking
print_status "Installing networking packages..."
sudo pacman -S --needed --noconfirm \
    networkmanager \
    bluez \
    bluez-utils

# Fonts
print_status "Installing fonts..."
sudo pacman -S --needed --noconfirm \
    ttf-jetbrains-mono-nerd \
    ttf-cascadia-mono-nerd \
    noto-fonts \
    noto-fonts-emoji

# Security
print_status "Installing security packages..."
sudo pacman -S --needed --noconfirm \
    gnome-keyring \
    ufw

# Theming
print_status "Installing theming packages..."
sudo pacman -S --needed --noconfirm \
    nwg-look \
    qt5ct \
    qt6ct \
    kvantum

# Gaming
print_status "Installing gaming packages..."
sudo pacman -S --needed --noconfirm \
    gamemode \
    lib32-nvidia-utils \
    wine \
    lutris

# Misc
print_status "Installing misc packages..."
sudo pacman -S --needed --noconfirm \
    qbittorrent \
    localsend

# AUR Packages
print_status "Installing AUR packages..."
yay -S --needed --noconfirm \
    zen-browser-bin \
    vesktop-bin \
    signal-desktop \
    tidal-hifi-bin \
    spotify \
    keeper-password-manager \
    gpu-screen-recorder \
    lazydocker \
    claude-code \
    visual-studio-code-bin \
    mullvad-vpn \
    ventoy-bin

# Set Zsh as default shell
print_status "Setting Zsh as default shell..."
chsh -s $(which zsh)

# Enable services
print_status "Enabling services..."
sudo systemctl enable --now docker
sudo systemctl enable --now bluetooth
sudo systemctl enable --now mullvad-daemon
sudo systemctl enable ufw
sudo ufw enable

# Add user to docker group
sudo usermod -aG docker $USER

# Create config directories
print_status "Creating config directories..."
mkdir -p ~/.config/{hypr,waybar,rofi,mako,ghostty,zsh}

# Setup Starship
print_status "Setting up Starship..."
echo 'eval "$(starship init zsh)"' >> ~/.zshrc
echo 'eval "$(zoxide init zsh)"' >> ~/.zshrc

print_status "=========================================="
print_status "Installation complete!"
print_status "=========================================="
echo ""
print_warning "Next steps:"
echo "1. Log out and back in (for Zsh and docker group)"
echo "2. Run 'gh auth login' to setup GitHub"
echo "3. Copy configs from ~/dotfiles/reference/"
echo "4. Set up Everforest theme"
echo "5. Reboot to apply all changes"
echo ""
print_warning "Your monitor config is saved in ~/dotfiles/reference/monitors.conf"
