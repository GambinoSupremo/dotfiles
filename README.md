# dotfiles

Configs for a Wayland desktop: Hyprland (primary), MangoWM and Niri,
Noctalia shell, Ghostty. NixOS-first: consumed
as a flake input of
[nixos-config](https://github.com/GambinoSupremo/nixos-config), which
deploys parts of it at build time.

## What is deployed where

- **Deployed by NixOS** (copied by nixos-config `home/dotfiles.nix`,
  symlinked into `~/.config`): `mango/`, `niri/`, `hypr/`, `ghostty/`. nixos-config also
  writes `hypr/hyprland.conf` (fallback) and `hypr/nixos.lua` when the
  overview plugin is enabled (currently disabled).
  Also consumed by NixOS: `starship/` (merged, not symlinked). Wallpapers
  live in the separate wallpapers repo.
- **Linked live by NixOS**: `nvim/` (LazyVim). nixos-config links
  `~/.config/nvim` straight to this checkout (not the pinned input), so edits
  apply at once and lazy.nvim can update `lazy-lock.json`; commit that file.

## Where to edit

| Change | File |
|---|---|
| Hyprland startup and imports | `hypr/hyprland.lua`, `hypr/autostart.lua` |
| Monitor resolution, scale, HDR | `hypr/monitor.lua` |
| Workspace assignments | `hypr/workspaces.lua` |
| Layout switching | `hypr/layouts.lua` |
| Shortcuts | `hypr/bind.lua`, `mango/bind.conf`, `niri/binds.kdl` |
| Window rules | `hypr/rule.lua`, `mango/rule.conf`, `niri/windowrules.kdl` |
| Terminal | `ghostty/config` |
| Prompt | `starship/starship.toml` |
| Neovim options and mappings | `nvim/lua/config/` |
| Neovim plugins and Nix support | `nvim/lua/plugins/` |

Open the checkout as a folder in Neovim or Zed. `.editorconfig` preserves
the four-space compositor style and two-space Neovim style. For Nix editing
tools, see [Neovim setup](nvim/INSTALL.md) and nixos-config's `docs/editing.md`.
Hyprland's `.luarc.json` points Lua tooling at the installed NixOS API stubs.

## Ground rules

- `hypr/autostart.lua` carries a header warning: nixos-config patches two of
  its lines by **exact text**. Rewording them fails that build on purpose —
  edit both repos together.
- Compositor and terminal edits reach the desktop after push and
  `nix flake update dotfiles` + rebuild. Neovim uses the live checkout above.
- Keybinds are one scheme: `niri/binds.kdl`, `hypr/bind.lua` and
  `mango/bind.conf` mirror each other (Mod=focus, +Shift=move window, +Ctrl=workspace/monitor,
  +Ctrl+Shift=carry across, Mod+Shift+1..6 = carry to workspace). Change all three or note the divergence in the file.
  Mod+1..6 are per monitor everywhere (hypr: Alienware 1-6, Philips 11-16
  named 1-6). Hyprland layouts switch per workspace via `hypr/layouts.lua`
  (Mod+Ctrl+A/S/D pick tile/scroller/dwindle; choices saved in `~/.local/state/hypr/layouts.lua`).
- Mac-style editing keys: keyd (nixos-config) turns Super+Z/X/C/V into
  Ctrl+Z / Shift+Delete / Ctrl+Insert / Shift+Insert before any compositor
  sees them, even with Shift/Ctrl/Alt held. Never bind Super with Z, X, C or V.
- `nvim/lua/plugins/dankcolors.lua` is hand-curated — never regenerate.
- Monitor identity: niri uses identity strings, hypr EDID descriptions, mango
  monitor models — never port names (the DP-N index flips between boots).
- Colour: Hyprland keeps the AW3423DW in sRGB for desktop use and switches to
  HDR for fullscreen HDR content. The mode switch can briefly blank the screen.
  The SUNSHINE virtual display, Mango, and Niri stay SDR.
- VRR is off on the Alienware in hypr (`vrr=0`): with the RX 9070 XT its
  G-SYNC module stutters every fullscreen game. Mango (enabled) and Niri
  (disabled) have VRR off too.
- Noctalia runtime files (`mango/noctalia.conf`, `niri/noctalia.kdl`,
  `ghostty/themes/noctalia`, `hypr/noctalia.lua` on NixOS) are generated or
  overwritten by Noctalia — treat repo copies as seeds, not sources of truth.
