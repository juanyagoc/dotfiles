-- Desactivar plugins innecesarios desde el inicio para evitar carga
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Establecer nivel de notificación (solo mensajes importantes)
vim.notify_level = vim.log.levels.INFO

-- Establecer el líder antes de cargar cualquier plugin (crítico para Lazy.nvim)
-- vim.g.mapleader = " "

-- Opcional: si usas variables de entorno
local mcp_hub_path = os.getenv("MCP_HUB_PATH")
if mcp_hub_path then
  vim.g.mcp_hub_path = mcp_hub_path
end

-- Cargar módulos personalizados de forma segura
local core_ok, _ = pcall(require, "juan.core")
local lazy_ok, _ = pcall(require, "juan.lazy")

-- Si falla alguno, notificar
if not core_ok then
  vim.notify("Error cargando juan.core", vim.log.levels.ERROR)
end

if not lazy_ok then
  vim.notify("Error cargando juan.lazy", vim.log.levels.ERROR)
end

-- Configuración básica predeterminada (fallback o inicial)
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.termguicolors = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.breakindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.mouse = "a"
