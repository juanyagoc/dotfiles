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
    "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "pyright", -- Python
        "clangd",  -- C / C++
        "jdtls",   -- Java
        "hls",     -- Haskell
        "texlab",  -- LaTeX
        "jsonls",  -- JSON
        "lua_ls",  -- Neovim config
        "efm",     -- Motor de Linters/Formatters
      },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "mason-org/mason.nvim" },
    opts = {
      ensure_installed = {
        "black",        -- Formateador Python
        "flake8",       -- Linter Python
        "clang-format", -- Formateador C/C++
        "cpplint",      -- Linter C/C++
        "fixjson",      -- Formateador JSON
        "stylua",       -- Formateador Lua
      },
      auto_update = false,
      run_on_start = true,
    },
  },
}

