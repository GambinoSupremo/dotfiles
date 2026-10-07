# dotfiles

Configs for Gavin's NixOS desktop: Hyprland (primary), Niri (backup), Noctalia
shell, Ghostty. nixos-config (~/nixos-config) consumes this repo as a pinned
`github:` flake input; see README.md for what gets deployed where.

## Rules

- Commit messages and comments read like a person wrote them. Never add
  Co-Authored-By or any AI attribution.
- Work on a branch (`cleanup/<topic>`), one commit per logical change.
  Gavin merges with `--ff-only`.
- NixOS-first: write NixOS names and paths directly (`zen-beta`, `ghostty`
  from PATH, `~/.config/...`). Nothing here needs to work on other distros.
- Do a read-only inventory first for anything big. Ask before anything
  irreversible (deleting files outside the repo, rewriting history, force).
- Use `rg`. In fish `grep` is aliased to `rg`; use `command grep` for GNU grep.
- Never edit `nvim/lua/plugins/dankcolors.lua` (hand-curated, never regenerate).
- Monitors are matched by identity string (EDID description/model), never by
  port name. The NVIDIA DP-N numbering flips between boots.
- The AW3423DW is in its own Creator/sRGB mode, so the compositors send plain
  sRGB (`cm = "srgb"` in hypr/monitor.lua). HDR is deliberately off
  (`cm_auto_hdr = false`) until desktop HDR works with Moonlight/Sunshine.
- `mango/` is kept for reference only. NixOS doesn't deploy it.

## Getting a change onto the system

Changes reach the system only after they're pushed here and then
`nix flake update dotfiles` is run in nixos-config. You may push `main`
after these checks pass, and must then say plainly what was pushed and why:

1. `niri validate -c niri/config.kdl` for niri changes.
2. `luac -p` on changed Lua files
   (`nix shell nixpkgs#lua5_4 -c luac -p hypr/<file>.lua`).
3. In nixos-config, build both hosts with
   `--override-input dotfiles path:/home/gav/Projects/dotfiles` and `diff -r`
   the `dotfiles-patched` output against the current one. Only the changes
   you meant should show up.

Push with a fast-forward of `main` only, after checking
`git log origin/main..main`. Don't push nixos-config; Gavin does that.

## Things that are easy to break

- hypr/autostart.lua: nixos-config still patches the two env-import
  `exec_cmd` lines (`dbus-update-activation-environment ...` and
  `systemctl --user import-environment ...`) by exact text. Changing them
  fails the nixos-config build, so change the patch in
  nixos-config home/dotfiles.nix at the same time.
- Noctalia rewrites `niri/noctalia.kdl` and `ghostty/themes/noctalia` at
  runtime; the repo copies are only seeds. `hypr/noctalia.lua` isn't in the
  repo (nixos-config seeds an empty stub).
- Keybinds mirror each other in niri/binds.kdl and hypr/bind.lua. Change both
  or note the difference in the file.
- Noctalia is started by its systemd user service. Don't add another launch
  in Hyprland autostart (it races the service).
