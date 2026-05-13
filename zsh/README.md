# ZSH config

XDG-compliant ZSH setup. ZDOTDIR is set system-wide via /etc/zsh/zshenv so
the interactive config lives at ~/.config/zsh/.zshrc.

## Dependencies
zsh, starship, zoxide, eza, bat

    sudo pacman -S zsh starship zoxide eza bat

## Install on a new machine

    sudo cp ~/dotfiles/zsh/etc-zshenv /etc/zsh/zshenv
    mkdir -p ~/.config/zsh
    ln -sf ~/dotfiles/zsh/.zshrc ~/.config/zsh/.zshrc
    chsh -s /usr/bin/zsh

Then open a new terminal.

History (~/.config/zsh/.zsh_history) is gitignored.
