local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- si no encuentra lazy lo clona de github
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

-- detecta los plugins y configura las notificaciones de sus actualizaciones
require("lazy").setup({ { import = "juan.plugins" } }, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = { notify = false, },
})
