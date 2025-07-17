-- .config/nvim/init.lua

-- Desactivar plugins innecesarios desde el inicio para evitar carga
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Establecer nivel de notificación (solo mensajes importantes)
vim.notify_level = vim.log.levels.INFO

-- Establecer el líder antes de cargar cualquier plugin (crítico para Lazy.nvim)
-- vim.g.mapleader = " "

-- Para variables de entorno
local mcp_hub_path = os.getenv("MCP_HUB_PATH")
if mcp_hub_path then
  vim.g.mcp_hub_path = mcp_hub_path
end

-- Cargar módulos personalizados
local function safe_require(mod)
  local ok, _ = pcall(require, mod)
  if not ok then
    vim.notify("Error cargando " .. mod, vim.log.levels.ERROR)
  end
end

safe_require("juan.core")
safe_require("juan.lazy")

