#!/bin/bash
# Install key apps on CachyOS MacBook

echo "Updating system..."
sudo pacman -Syu --noconfirm

echo "Installing essential apps..."

# Apps that definitely exist in CachyOS repos
sudo pacman -S --noconfirm \
  base-devel \
  git \
  github-cli \
  zsh \
  zoxide \
  starship \
  kitty \
  ghostty \
  neovim \
  ripgrep \
  fd \
  fzf \
  bat \
  eza \
  btop \
  fastfetch \
  niri \
  mangowm \
  noctalia-shell \
  brightnessctl \
  slurp \
  grim \
  wl-clipboard \
  wtype \
  wlr-randr \
  imagemagick \
  ffmpeg \
  mpv \
  vlc \
  firefox \
  ttf-meslo-nerd \
  noto-fonts-emoji \
  papirus-icon-theme

# Try to install from AUR (if paru/yay available)
if command -v paru &> /dev/null; then
  echo "Installing AUR packages with paru..."
  paru -S --noconfirm zed bibata-cursor-theme-bin || true
elif command -v yay &> /dev/null; then
  echo "Installing AUR packages with yay..."
  yay -S --noconfirm zed bibata-cursor-theme-bin || true
else
  echo "paru/yay not found. Install zed/bibata manually with: paru -S zed bibata-cursor-theme-bin"
fi

echo "Done! Your apps are installed."
