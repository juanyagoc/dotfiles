-- .config/nvim/init.lua

-- Disable not necessary plugins at the beginning
vim.g.loaded_matchit = 1
vim.g.loaded_matchparen = 1

-- Notify only important things
vim.notify_level = vim.log.levels.INFO

-- For environment variables
local mcp_hub_path = os.getenv("MCP_HUB_PATH")
if mcp_hub_path then
  vim.g.mcp_hub_path = mcp_hub_path
end

-- Load personalized modules
local function safe_require(mod)
  local ok, _ = pcall(require, mod)
  if not ok then
    vim.notify("Error cargando " .. mod, vim.log.levels.ERROR)
  end
end

safe_require("juan.core")
safe_require("juan.lazy")

