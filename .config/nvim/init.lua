-- ~/.config/nvim/init.lua

-- Load personalized modules with this safe loading function
local function safe_require(mod)
  local ok, err = pcall(require, mod)
  if not ok then
    vim.notify("Error cargando " .. mod .. ":\n" .. err, vim.log.levels.ERROR)
  end
end

safe_require("juan.core")
safe_require("juan.lazy")
