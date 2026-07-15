# Cleanup decisions — 2026-07-14

Judgment calls from the deep-cleanup pass. Pairs with nixos-config/DECISIONS.md.

## Changed
- Deleted: install.sh, install-apps.sh (Arch installers), mango/theme.conf.bak
  (unsourced, was deployed as a stray), hypr/theme.lua (never require()d and
  contradicted the live config — vrr=0, cm off, qt6ct), noctalia/config.toml
  (live copy is nixos-config home/noctalia/config.toml), ghostty/config.ghostty
  (one-line duplicate).
- hypr/bind.lua: SUPER+SHIFT+S double-bind resolved — screenshot kept,
  signal-desktop spawn dropped (autostarts on ws5 anyway). Coupled
  nixos-config commit removes the now-targetless sed.
- mango: fullscreen-only VRR via monitorrule vrr:0 + windowrule
  vrr_only_fullscreen:1 on steam_app_ (mango has no vrr:2; monitor vrr is
  clamped to 0/1 in parse_config.h).
- niri: __GL_VRR_ALLOWED/__GL_GSYNC_ALLOWED removed from environment block
  (session-wide via nvidia.nix on NixOS).
- Every NixOS-patched file got a header warning that sed targets match
  exact line text.
- Stale comment fixes: rule.conf opacity 0.97→0.95; DP probe-order caveats
  in tag.conf/rule.conf/workspaces.lua.
- README.md created (deployed-vs-standalone mapping, repo conventions).

## Left alone
- fish/, zsh/, packages/: portable reference configs, kept in place (owner
  decision; fish/zsh are inert on NixOS).
- nvim/: whole LazyVim tree currently NOT deployed on NixOS (HM runs a
  minimal programs.neovim). Kept; deploy-or-migrate is a separate decision.
  dankcolors.lua untouched (hand-curated).
- Keybind drift left as documented divergence, not fixed: signal spawn key
  (mango S+S+s / niri M+S+G / hypr none), SUPER+X (cut on hypr vs overview
  on mango/niri), zed key, screenshot schemes, 9 mango tags vs 6 elsewhere.
- hypr/autostart.lua tidal-hifi stays commented out (mango/niri autostart
  it) — assumed deliberate.
- niri windowrules.kdl opacity layering (0.97 global, NixOS append
  re-overrides 4 apps) — net effect matches mango; ugly but correct.
- monitor identity strings, HDR config (hypr/monitor.lua), 255-char-limit
  comment: untouched — dankcolors is hand-curated (never regenerate),
  monitor identity strings and HDR config left as-is.

## Unsure / watch
- zsh/.zshrc arkenfox-update alias references the old Arch profile path;
  the NixOS port lives in nixos-config home/shell.nix and is inert (see
  that repo's DECISIONS.md).
- mango/tag.conf + rule.conf still match ^DP-2$/^DP-1$ only; if probe order
  ever flips, layouts/comms placement degrade silently (documented, not
  fixed — mango tagrule regexes could take both names if it ever bites).
