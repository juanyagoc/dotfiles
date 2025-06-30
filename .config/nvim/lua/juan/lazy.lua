local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- si no encuentra lazy lo clona de github
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- detecta los plugins y configura las notificaciones de sus actualizaciones
require("lazy").setup({ { import = "juan.plugins" } }, {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
