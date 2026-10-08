-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- keyd sends Super+Z as Ctrl+Z; undo instead of suspending nvim.
vim.keymap.set({ "n", "i" }, "<C-z>", "<cmd>undo<cr>", { desc = "Undo (Super+Z via keyd)" })
