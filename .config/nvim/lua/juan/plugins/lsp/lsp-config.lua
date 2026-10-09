return {
    {
        "saghen/blink.cmp",
        event = { "InsertEnter", "CmdlineEnter" },
        dependencies = {
            { "L3MON4D3/LuaSnip", build = "make install_jsregexp" },
            "rafamadriz/friendly-snippets",
        },
        version = "*",
        opts = {
            keymap = {
                preset = "none",
                ["<C-Space>"] = { "show", "hide" },
                ["<CR>"] = { "accept", "fallback" },
                ["<C-j>"] = { "select_next", "fallback" },
                ["<C-k>"] = { "select_prev", "fallback" },
                ["<Tab>"] = { "snippet_forward", "fallback" },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },
            },
            signature = { window = { border = "rounded" } },
            sources = {
                default = { "lazydev", "lsp", "path", "buffer", "snippets" },
                providers = {
                    lazydev = { name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100 },
                },
            },
            completion = {
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                    },
                },
            },
            snippets = { preset = "luasnip" },
            fuzzy = {
                implementation = "prefer_rust",
                prebuilt_binaries = { download = true },
            },
        },
        config = function(_, opts)
            require("luasnip.loaders.from_vscode").lazy_load() -- friendly-snippets
            require("blink.cmp").setup(opts)
        end,
    },

    -- ============================================================================
    -- CONFIGURACIONES DE LINTERS Y FORMATTERS
    -- ============================================================================
    {
        "creativenull/efmls-configs-nvim",
        lazy = true,
    },

    -- ============================================================================
    -- CONFIGURACIÓN PRINCIPAL LSP
    -- ============================================================================
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- mason debe cargarse antes para añadir sus binarios al PATH
            "mason-org/mason.nvim",
            "mason-org/mason-lspconfig.nvim",
            "creativenull/efmls-configs-nvim",
        },
        config = function()
            -- blink.cmp registra sus capabilities en vim.lsp.config("*") automáticamente
            local diagnostic_signs = { Error = " ", Warn = " ", Hint = "", Info = "" }
            vim.diagnostic.config({
                virtual_text = { prefix = "●", spacing = 4 },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = diagnostic_signs.Error,
                        [vim.diagnostic.severity.WARN] = diagnostic_signs.Warn,
                        [vim.diagnostic.severity.INFO] = diagnostic_signs.Info,
                        [vim.diagnostic.severity.HINT] = diagnostic_signs.Hint,
                    },
                },
                underline = true,
                update_in_insert = false,
                severity_sort = true,
                float = {
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                    focusable = false,
                    style = "minimal",
                },
            })

            -- Formatea con efm si está conectado al buffer; si no, con cualquier LSP que pueda
            local function format_buffer()
                local bufnr = vim.api.nvim_get_current_buf()
                local has_efm = #vim.lsp.get_clients({ bufnr = bufnr, name = "efm" }) > 0
                vim.lsp.buf.format({
                    async = true,
                    filter = function(client) return not has_efm or client.name == "efm" end,
                })
            end

            -- ----------------------------------------------------------------------
            -- Atajos de teclado que se activan SÓLO cuando un LSP se conecta
            -- (0.12 ya trae grn, gra, grr, gri, ]d y [d por defecto)
            -- ----------------------------------------------------------------------
            local function lsp_on_attach(ev)
                local function lsp_definitions() require("fzf-lua").lsp_definitions({ jump1 = true }) end
                local function map(lhs, rhs, desc)
                    vim.keymap.set("n", lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
                end

                -- Navegación con Fzf-Lua
                map("<leader>gd", lsp_definitions, "LSP: Definición (fzf)")
                map("<leader>gD", vim.lsp.buf.definition, "LSP: Definición")
                map("<leader>gS", function() vim.cmd.vsplit(); vim.lsp.buf.definition() end, "LSP: Definición en split")
                map("<leader>fd", lsp_definitions, "LSP: Definición (fzf)")
                map("<leader>fr", "<cmd>FzfLua lsp_references<cr>", "LSP: Referencias")
                map("<leader>ft", "<cmd>FzfLua lsp_typedefs<cr>", "LSP: Tipos")
                map("<leader>fs", "<cmd>FzfLua lsp_document_symbols<cr>", "LSP: Símbolos del documento")
                map("<leader>fw", "<cmd>FzfLua lsp_workspace_symbols<cr>", "LSP: Símbolos del workspace")
                map("<leader>fi", "<cmd>FzfLua lsp_implementations<cr>", "LSP: Implementaciones")

                -- Acciones de código y refactorización
                map("<leader>ca", vim.lsp.buf.code_action, "LSP: Code action")
                map("<leader>rn", vim.lsp.buf.rename, "LSP: Renombrar")
                map("<leader>cf", format_buffer, "LSP: Formatear buffer")

                -- Diagnósticos
                map("<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, "Diagnósticos de la línea")
                map("<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, "Diagnóstico bajo el cursor")
                map("<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, "Siguiente diagnóstico")
                map("<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, "Diagnóstico anterior")
            end

            -- Autocommand para asignar las teclas al abrir un archivo compatible
            local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", { group = lsp_group, callback = lsp_on_attach })

            -- ----------------------------------------------------------------------
            -- Inicialización de Servidores LSP
            -- ----------------------------------------------------------------------
            vim.lsp.config("clangd", {
                cmd = {
                    "/opt/homebrew/opt/llvm/bin/clangd",
                    "--query-driver=/opt/homebrew/bin/g++-16,/opt/homebrew/bin/gcc-16,/usr/local/bin/g++-16,/usr/local/bin/gcc-16",
                },
            })
            vim.lsp.config("lua_ls", {
                settings = { Lua = { telemetry = { enable = false } } }, -- los globals de vim los aporta lazydev
            })
            vim.lsp.config("sqlls", {
                filetypes = { "sql", "mysql", "postgresql" },
                root_dir = function(_, on_dir) on_dir(vim.fn.getcwd()) end,
            })

            -- ----------------------------------------------------------------------
            -- Inicialización de EFM (Formatters y Linters)
            -- ----------------------------------------------------------------------
            local stylua = require("efmls-configs.formatters.stylua")
            local ruff = require("efmls-configs.linters.ruff")
            local cppcheck = require("efmls-configs.linters.cppcheck")
            local sqlformatter = require("efmls-configs.formatters.sql-formatter")

            vim.lsp.config("efm", {
                filetypes = {
                    "c", "cpp", "python", "lua", "sql"
                },
                init_options = { documentFormatting = true },
                settings = {
                    languages = {
                        c = { cppcheck },
                        cpp = { cppcheck },
                        python = { ruff },
                        lua = { stylua },
                        sql = { sqlformatter },
                    },
                },
            })

            vim.lsp.enable({
                "pyright",
                "clangd",
                "jdtls",
                "hls",
                "texlab",
                "jsonls",
                "lua_ls",
                "sqlls",
                "efm",
            })
        end,
    },
}
