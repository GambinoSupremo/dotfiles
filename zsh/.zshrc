# ~/.config/zsh/.zshrc -- symlinked from ~/dotfiles/zsh/.zshrc

# PATH
export PATH="$HOME/.local/bin:/usr/local/bin:$PATH"

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE="$ZDOTDIR/.zsh_history"

# Aliases
alias ls='eza --icons'
alias ll='eza -la --icons'
alias la='eza -a --icons'
alias cat='bat'
alias cd='z'

# Init tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Keybinds
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Clipboard / misc
alias arkenfox-update='bash "$HOME/.zen/8kqnmniv.Default Profile/updater.sh"'
alias cb='wl-copy'
alias tcb='tee >(wl-copy)'
