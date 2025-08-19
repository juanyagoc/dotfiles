-- Disable not necessary plugins at the beginning
vim.g.loaded_matchit = 1
vim.g.loaded_node_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
--vim.g.loaded_matchparen = 1

-- For environment variables
local mcp_hub_path = os.getenv("MCP_HUB_PATH")
if mcp_hub_path then
  vim.g.mcp_hub_path = mcp_hub_path
end

require("juan.core.options")
require("juan.core.keymaps")
