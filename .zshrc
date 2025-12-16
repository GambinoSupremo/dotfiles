# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# Aliases
alias ls='eza --icons'
alias ll='eza -la --icons'
alias la='eza -a --icons'
alias cat='bat'
alias grep='rg'
alias cd='z'

# Init tools
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Keybinds
bindkey -e
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward
