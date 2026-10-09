-- ~/.config/nvim/lua/juan/lazy.lua

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- si no encuentra lazy lo clona de github
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg"},
      { out, "WarningMsg"},
      { "\nPress any key to exit"},
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Detect the listed plugins and configure its update notifications
require("lazy").setup(
    {
        { import = "juan.plugins"     }, -- main plugins folder
        { import = "juan.plugins.lsp" }, -- lspconfig subfolder
    },
    {
      install = { colorscheme = { "kanagawa-dragon" } },
      checker = {
        enabled = true,
        notify = false,
      },
      change_detection = { notify = false, },
      performance = {
        rtp = {
          disabled_plugins = { "gzip", "netrwPlugin", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
        },
      },
    }
)
