# Gavin's Dotfiles Project

## Goal
Create a personal, reproducible Hyprland setup on CachyOS that can be deployed on any machine or VM with a single script. This replaces Omarchy with a custom, de-branded setup.

## System Overview
- **Distro:** CachyOS
- **Filesystem:** Btrfs (with snapper snapshots)
- **Bootloader:** Limine
- **WM:** Hyprland
- **Shell:** Zsh + Powerlevel10k
- **Theme:** Everforest Dark

## Hardware
- **Main Monitor (DP-2):** Dell AW3423DW 3440x1440@175Hz (right)
- **Secondary Monitor (DP-1):** Philips 4K 3840x2160@60Hz, scale 1.5 (left)
- **GPU:** NVIDIA

## Core Components
| Component | App |
|-----------|-----|
| Terminal | Ghostty |
| Bar | Waybar |
| Launcher | Rofi |
| Notifications | Mako |
| File Manager | Nautilus |
| Browser | Zen |
| Lock Screen | Hyprlock |

## Key Apps
Vesktop, Signal, Obsidian, Tidal, Spotify, Steam, OBS, Mullvad VPN, Keeper Password Manager, VS Code, Docker, Claude Code

## Color Scheme (Everforest Dark)
```
base:    #2d353b
mantle:  #343f44
text:    #d3c6aa
red:     #e67e80
green:   #a7c080
blue:    #7fbbb3
yellow:  #dbbc7f
```

## Directory Structure
```
~/dotfiles/
├── install.sh           # Main install script
├── CLAUDE.md            # This file
├── hypr/                # Hyprland config
├── waybar/              # Waybar config + style
├── rofi/                # Rofi config + theme
├── ghostty/             # Terminal config
├── mako/                # Notification config
├── .zshrc               # Shell config
└── reference/           # Old configs for reference
```

## Keybinds
- Super + Space → Rofi
- Super + Return → Terminal
- Super + Q → Close (killactive)
- Super + C → Copy (universal)
- Super + V → Paste (universal)
- Super + Shift + V → Toggle floating
- Super + Shift + B → Browser
- Super + Shift + D → Vesktop
- Super + Shift + S → Signal
- Super + Shift + M → Tidal
- Super + Shift + O → Obsidian
- Alt + Shift + S → Screenshot
- Ctrl + Super + Arrow → Media controls

## Workspace Layout
- Workspaces 1-3 on DP-2 (main ultrawide)
- Workspaces 4-6 on DP-1 (secondary 4K)

## Future Goals
- [ ] Theme switching script (like Omarchy had)
- [ ] More wallpaper options
- [ ] Improved install.sh that also deploys configs
- [ ] hyprlock styling improvements
- [ ] Add more window rules for apps

## Notes for Claude Code
- All configs use Everforest Dark colors
- Keep things minimal and clean
- Prefer Wayland-native solutions
- Test changes with `hyprctl reload`
- Waybar reload: `pkill waybar && waybar &`
- Rofi test: `rofi -show drun`
