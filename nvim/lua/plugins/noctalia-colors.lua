-- Colors from Noctalia's neovim template (writes lua/matugen.lua, untracked).
-- Noctalia sends SIGUSR1 after a theme change; reload then.
local function apply()
  package.loaded.matugen = nil
  local ok, matugen = pcall(require, "matugen")
  if ok then matugen.setup() else vim.cmd.colorscheme("habamax") end
end

return {
  { "RRethy/base16-nvim", lazy = false, priority = 1000 },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = function()
        apply()
        vim.api.nvim_create_autocmd("Signal", { pattern = "SIGUSR1", callback = function() vim.schedule(apply) end })
      end,
    },
  },
}
