# Interactive tool hooks for non-NixOS machines (e.g. macOS with Homebrew).
# On NixOS, Home Manager generates config.fish and loads only conf.d/shared.fish.
status is-interactive; or return

command -q zoxide; and zoxide init fish | source
command -q atuin; and atuin init fish --disable-up-arrow | source
command -q direnv; and direnv hook fish | source
if test "$TERM" != dumb; and command -q starship
    starship init fish | source
end
