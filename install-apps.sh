#!/bin/bash
# Install key apps on CachyOS MacBook

# Update system first
sudo pacman -Syu --noconfirm

# Core apps you likely use
APPS="
base-devel
git
github-cli
zsh
zoxide
starship
kitty
ghostty
zed
neovim
ripgrep
fd
fzf
bat
eza
btop
fastfetch
niri
mangowm
noctalia-shell
noctalia-qs
brightnessctl
slurp
grim
wl-clipboard
wtype
wlr-randr
imagemagick
ffmpeg
mpv
vlc
qbittorrent
obs-studio-browser
signal-desktop
vesktop
element-desktop
firefox
zen-browser-bin
steam
lutris
gamemode
gamescope
mangohud
pokemon-colorscripts-git
papirus-icon-theme
bibata-cursor-theme-bin
ttf-meslo-nerd
noto-fonts-emoji
"

echo "Installing essential apps..."
sudo pacman -S --noconfirm $APPS

echo "Done! Your apps are installed."
echo "To use Niri/MangoWM, set your session at login."
