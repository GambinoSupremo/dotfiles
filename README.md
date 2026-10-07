# dotfiles

Configs for a Wayland desktop: Hyprland (primary), Niri (secondary),
MangoWM (not deployed by NixOS), Noctalia shell, Ghostty. Consumed two ways:
standalone on any Linux, or as a flake input of
[nixos-config](https://github.com/GambinoSupremo/nixos-config), which
patches and deploys parts of it at build time.

## What is deployed where

- **Deployed by NixOS** (patched by nixos-config `home/dotfiles.nix`,
  symlinked into `~/.config`): `niri/`, `hypr/`, `ghostty/`.
  Also consumed by NixOS: `starship/` (merged, not symlinked). Wallpapers
  live in the separate wallpapers repo.
- **Standalone / portable** (NOT deployed by NixOS): `fish/`, `zsh/`,
  `packages/` (Arch package lists), `nvim/` (LazyVim tree; on NixOS,
  home-manager currently runs a minimal programs.neovim instead).
- **Not deployed, reference only**: `mango/` (MangoWM is not deployed by NixOS).

## Ground rules

- Files deployed by NixOS carry a header warning: nixos-config seds match
  **exact line text** in them. Rewording a matched line fails that build on
  purpose — edit both repos together, then `nix flake update dotfiles` +
  rebuild (dotfile edits are never live until then).
- Keybinds are one scheme: `niri/binds.kdl` and `hypr/bind.lua` mirror
  each other (Mod=focus, +Shift=move window, +Ctrl=workspace/monitor,
  +Ctrl+Alt=move across). Change both or note the divergence in the file.
  `mango/bind.conf` is not deployed by NixOS.
- `nvim/lua/plugins/dankcolors.lua` is hand-curated — never regenerate.
- Monitor identity: niri uses identity strings (never port names — the
  NVIDIA DP-N index flips with probe order). Mango/hypr port-name configs
  carry caveat comments; monitor.conf gets both names on NixOS.
- HDR is deliberately off: `hypr/monitor.lua` runs the AW3423DW in SDR
  (`cm = "dcip3"`, `supports_hdr = 0`; `cm_auto_hdr = false` in
  `hypr/config.lua`) until desktop HDR works with Moonlight/Sunshine
  streaming. Mango has
  no working HDR (scenefx/GLES lacks input_color_transform; works on the
  wl-only vulkan branch) — don't re-test it casually.
- VRR is fullscreen-games-only everywhere (QD-OLED gamma flicker):
  hypr `vrr=2`, niri `on-demand` + steam_app rule, mango `vrr:0` +
  `vrr_only_fullscreen:1`.
- Noctalia runtime files (`mango/noctalia.conf`, `niri/noctalia.kdl`,
  `ghostty/themes/noctalia`, `hypr/noctalia.lua` on NixOS) are generated or
  overwritten by Noctalia — treat repo copies as seeds, not sources of truth.
