# dotfiles

Configs for a Wayland desktop: Hyprland (primary), MangoWM and Niri,
Noctalia shell, Ghostty. NixOS-first: consumed
as a flake input of
[nixos-config](https://github.com/GambinoSupremo/nixos-config), which
deploys parts of it at build time.

## What is deployed where

- **Deployed by NixOS** (copied by nixos-config `home/dotfiles.nix`,
  symlinked into `~/.config`): `mango/`, `niri/`, `hypr/`, `ghostty/`. nixos-config also
  writes `hypr/hyprland.conf` (fallback) and `hypr/nixos.lua` (desktop only).
  Also consumed by NixOS: `starship/` (merged, not symlinked). Wallpapers
  live in the separate wallpapers repo.
- **Linked live by NixOS**: `nvim/` (LazyVim). nixos-config links
  `~/.config/nvim` straight to this checkout (not the pinned input), so edits
  apply at once and lazy.nvim can update `lazy-lock.json`; commit that file.

## Ground rules

- `hypr/autostart.lua` carries a header warning: nixos-config patches two of
  its lines by **exact text**. Rewording them fails that build on purpose —
  edit both repos together.
- Dotfile edits are never live until they're pushed and nixos-config runs
  `nix flake update dotfiles` + rebuild.
- Keybinds are one scheme: `niri/binds.kdl`, `hypr/bind.lua` and
  `mango/bind.conf` mirror each other (Mod=focus, +Shift=move window, +Ctrl=workspace/monitor,
  +Ctrl+Alt=move across). Change all three or note the divergence in the file.
- Mac-style editing keys: keyd (nixos-config) turns Super+Z/X/C/V into
  Ctrl+Z / Shift+Delete / Ctrl+Insert / Shift+Insert before any compositor
  sees them, even with Shift/Ctrl/Alt held. Never bind Super with Z, X, C or V.
- `nvim/lua/plugins/dankcolors.lua` is hand-curated — never regenerate.
- Monitor identity: niri uses identity strings, hypr EDID descriptions, mango
  monitor models — never port names (the NVIDIA DP-N index flips with probe
  order).
- Colour: the AW3423DW runs in its own Creator mode with the sRGB colour
  space (gamma 2.2), so it does the sRGB clamp itself. The compositors send
  plain sRGB (`cm = "srgb"` in `hypr/monitor.lua`; niri has no colour
  management to set). HDR is deliberately off (`supports_hdr = 0`;
  `cm_auto_hdr = false` in `hypr/config.lua`) until desktop HDR works with
  Moonlight/Sunshine streaming. Mango has native HDR since 0.15.0; it stays off there too.
- VRR is fullscreen-games-only everywhere (QD-OLED gamma flicker):
  hypr `vrr=2`, niri `on-demand` + steam_app rule, mango `vrr:0` +
  `vrr_only_fullscreen:1`.
- Noctalia runtime files (`mango/noctalia.conf`, `niri/noctalia.kdl`,
  `ghostty/themes/noctalia`, `hypr/noctalia.lua` on NixOS) are generated or
  overwritten by Noctalia — treat repo copies as seeds, not sources of truth.
