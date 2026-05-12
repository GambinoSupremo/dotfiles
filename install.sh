#!/bin/bash
# Install apps on CachyOS from package lists
# Usage: ./install.sh  (run from dotfiles repo root)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NATIVE_LIST="$SCRIPT_DIR/packages/native.txt"
AUR_LIST="$SCRIPT_DIR/packages/aur.txt"

echo "==> Syncing system..."
sudo pacman -Syu --noconfirm

# --- Native packages ---
if [[ -f "$NATIVE_LIST" ]]; then
  echo "==> Installing native packages from $NATIVE_LIST..."
  # Strip comments and blank lines, then install with --needed to skip already-installed
  mapfile -t native_pkgs < <(grep -v '^\s*#' "$NATIVE_LIST" | grep -v '^\s*$')
  sudo pacman -S --needed --noconfirm "${native_pkgs[@]}"
else
  echo "!! $NATIVE_LIST not found, skipping native packages"
fi

# --- Bootstrap paru if missing ---
if ! command -v paru &> /dev/null; then
  echo "==> paru not found, bootstrapping from AUR..."
  tmpdir="$(mktemp -d)"
  git clone https://aur.archlinux.org/paru.git "$tmpdir/paru"
  (cd "$tmpdir/paru" && makepkg -si --noconfirm)
  rm -rf "$tmpdir"
fi

# --- AUR packages ---
if [[ -f "$AUR_LIST" ]]; then
  echo "==> Installing AUR packages from $AUR_LIST..."
  mapfile -t aur_pkgs < <(grep -v '^\s*#' "$AUR_LIST" | grep -v '^\s*$')
  paru -S --needed --noconfirm "${aur_pkgs[@]}"
else
  echo "!! $AUR_LIST not found, skipping AUR packages"
fi

echo "==> Done."
