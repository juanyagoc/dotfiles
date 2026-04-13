-- ~/.config/nvim/init.lua

-- Load personalized modules with this safe loading function
local function safe_require(mod)
  local ok, _ = pcall(require, mod)
  if not ok then
    vim.notify("Error cargando " .. mod, vim.log.levels.ERROR)
  end
end

safe_require("juan.core")
safe_require("juan.lazy")

vim.cmd.colorscheme("kanagawa-dragon")

