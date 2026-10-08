# Install

On NixOS, nixos-config links `~/.config/nvim` to `~/Projects/dotfiles/nvim`
(home/programs.nix, mkOutOfStoreSymlink), so there's nothing to do by hand.
Edits here apply without a rebuild.

Launch nvim. LazyVim will install all plugins automatically based on
lazy-lock.json, which pins exact versions for reproducibility across machines.

First launch downloads plugins to ~/.local/share/nvim/lazy/ (machine-local,
regenerated as needed).

Mason will install LSPs/formatters/linters per :Mason on first use; nix-ld
lets its downloaded binaries run on NixOS.
