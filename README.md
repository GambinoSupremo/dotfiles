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
  Mod+1..6 are per monitor everywhere (hypr: Alienware 1-6, Philips 11-16
  named 1-6). Hyprland layouts switch per workspace via `hypr/layouts.lua`
  (Mod+N cycles; choices saved in `~/.local/state/hypr/layouts.lua`).
- Mac-style editing keys: keyd (nixos-config) turns Super+Z/X/C/V into
  Ctrl+Z / Shift+Delete / Ctrl+Insert / Shift+Insert before any compositor
  sees them, even with Shift/Ctrl/Alt held. Never bind Super with Z, X, C or V.
- `nvim/lua/plugins/dankcolors.lua` is hand-curated — never regenerate.
- Monitor identity: niri uses identity strings, hypr EDID descriptions, mango
  monitor models — never port names (the DP-N index flips between boots).
- Colour: Hyprland runs the AW3423DW in always-on HDR (`cm = "hdr"`,
  `sdrbrightness = 2.0` in `hypr/monitor.lua`; monitor set to HDR 400 True
  Black). SDR apps are mapped in with gamma 2.2. `cm_auto_hdr = false` keeps it
  from switching modes (which blanks the screen). niri and mango (off) are
  still SDR.
- VRR is off on the Alienware in hypr (`vrr=0`): with the RX 9070 XT its
  G-SYNC module stutters every fullscreen game. niri/mango (off) still have
  their old fullscreen-only VRR rules.
- Noctalia runtime files (`mango/noctalia.conf`, `niri/noctalia.kdl`,
  `ghostty/themes/noctalia`, `hypr/noctalia.lua` on NixOS) are generated or
  overwritten by Noctalia — treat repo copies as seeds, not sources of truth.
