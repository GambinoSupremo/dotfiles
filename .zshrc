# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
source /usr/share/cachyos-zsh-config/cachyos-config.zsh
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Gavin's additions
alias ls='eza --icons'
alias ll='eza -la --icons'
alias cat='bat'
alias grep='rg'
alias find='fd'

# Zoxide
eval "$(zoxide init zsh)"

# FZF keybinds
source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh
