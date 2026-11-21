# Shared interactive Fish config (NixOS + macOS Homebrew).
status is-interactive; or return

set -g fish_greeting ""
fish_add_path -g ~/.local/bin

# Homebrew PATH on Apple Silicon Macs (no-op on Linux).
if test -x /opt/homebrew/bin/brew
    eval (/opt/homebrew/bin/brew shellenv)
end

# Abbreviations expand in place so the real commands stay visible.
if command -q eza
    abbr -a ls 'eza --icons --group-directories-first'
    abbr -a la 'eza -la --icons --group-directories-first'
    abbr -a ll 'eza -l --icons --group-directories-first'
    abbr -a tree 'eza --tree --icons --group-directories-first'
end
command -q bat; and abbr -a cat bat
command -q rg; and abbr -a grep rg
if command -q ouch
    abbr -a compress 'ouch compress'
    abbr -a decompress 'ouch decompress'
end

# A krabby Pokémon on each new shell; 1 in 40 is shiny, with a sparkle at its top right.
if command -q krabby
    set -l shiny
    test (random 1 40) -eq 1; and set shiny --shiny
    set -l art (krabby random --no-title $shiny 2>/dev/null)
    # Drop krabby's blank padding rows so the prompt sits close under the sprite.
    while set -q art[1]; and test -z (string replace -ra '\e\[[0-9;]*m' "" -- $art[-1] | string trim)
        set -e art[-1]
    end
    while set -q art[1]; and test -z (string replace -ra '\e\[[0-9;]*m' "" -- $art[1] | string trim)
        set -e art[1]
    end
    if set -q art[1]
        set -q shiny[1]; and set art[1] "$art[1]  ✨"
        printf '%s\n' $art
    end
end
