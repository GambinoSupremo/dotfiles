# Install on a new machine

Assumes ~/dotfiles is already cloned.

    sudo pacman -S neovim ripgrep fd
    rm -rf ~/.config/nvim   # if a default config exists
    ln -sfn ~/dotfiles/nvim ~/.config/nvim

Launch nvim. LazyVim will install all plugins automatically based on
lazy-lock.json, which pins exact versions for reproducibility across machines.

First launch downloads plugins to ~/.local/share/nvim/lazy/ (gitignored,
machine-local, regenerated as needed).

Mason will install LSPs/formatters/linters per :Mason on first use.
