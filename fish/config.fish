# Standalone fish config for non-NixOS machines.
# On NixOS this directory is NOT deployed — home-manager owns fish there
# (nixos-config home/shell.nix) and replicates these aliases/inits.

if status is-interactive
# Commands to run in interactive sessions can go here
end
starship init fish | source
zoxide init fish --cmd cd | source
set -g fish_greeting

# Generated for envman. Do not edit.
test -s ~/.config/envman/load.fish; and source ~/.config/envman/load.fish
