return {
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Abrir Mason" } },
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
      },
    },
  },
  {
    -- se carga como dependencia de nvim-lspconfig (ver lsp-config.lua)
    "mason-org/mason-lspconfig.nvim",
    lazy = true,
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "pyright", -- Python
        "jdtls",   -- Java
        "hls",     -- Haskell
        "texlab",  -- LaTeX
        "jsonls",  -- JSON
        "lua_ls",  -- Neovim config
        "efm",     -- Motor de Linters/Formatters
        "sqlls",   -- SQL
      },
      automatic_enable = false, -- los servidores se activan con vim.lsp.enable en lsp-config.lua
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "ruff",         -- Linter y formatter Python
        "stylua",       -- Formateador Lua
        "sql-formatter",-- Formateador de SQL
      },
      auto_update = false,
      run_on_start = true,
    },
    config = function(_, opts)
      local mti = require("mason-tool-installer")
      mti.setup(opts)
      mti.run_on_start() -- su autocmd de VimEnter ya pasó al cargar en VeryLazy
    end,
  },
}
