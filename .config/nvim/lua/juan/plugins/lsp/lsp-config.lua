return {
    {
        "saghen/blink.cmp",
        dependencies = {
            "L3MON4D3/LuaSnip", -- Soporte para snippets
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
            sources = { default = { "lsp", "path", "buffer", "snippets" } },
            completion = {
                menu = {
                    draw = {
                        columns = { { "kind_icon" }, { "label", "label_description", gap = 1 } },
                    },
                },
            },
            snippets = {
                expand = function(snippet)
                    require("luasnip").lsp_expand(snippet)
                end,
            },
            fuzzy = {
                implementation = "prefer_rust",
                prebuilt_binaries = { download = true },
            },
        },
    },

    -- ============================================================================
    -- CONFIGURACIONES DE LINTERS Y FORMATTERS (EFM)
    -- ============================================================================
    {
        "creativenull/efmls-configs-nvim",
        dependencies = { "neovim/nvim-lspconfig" },
    },

    -- ============================================================================
    -- CONFIGURACIÓN PRINCIPAL LSP (El "Cerebro")
    -- ============================================================================
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "saghen/blink.cmp",
            "creativenull/efmls-configs-nvim",
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
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
                    source = "always",
                    header = "",
                    prefix = "",
                    focusable = false,
                    style = "minimal",
                },
            })

            -- ----------------------------------------------------------------------
            -- Atajos de teclado que se activan SÓLO cuando un LSP se conecta
            -- ----------------------------------------------------------------------
            local function lsp_on_attach(ev)
                local client = vim.lsp.get_client_by_id(ev.data.client_id)
                if not client then return end
                local bufnr = ev.buf
                local opts = { noremap = true, silent = true, buffer = bufnr }

                local fzf = require("fzf-lua")

                -- Navegación con Fzf-Lua
                vim.keymap.set("n", "<leader>gd", function() fzf.lsp_definitions({ jump1 = true }) end, opts)
                vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, opts)
                vim.keymap.set("n", "<leader>gS", function() vim.cmd("vsplit"); vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "<leader>fd", function() fzf.lsp_definitions({ jump1 = true }) end, opts)
                vim.keymap.set("n", "<leader>fr", fzf.lsp_references, opts)
                vim.keymap.set("n", "<leader>ft", fzf.lsp_typedefs, opts)
                vim.keymap.set("n", "<leader>fs", fzf.lsp_document_symbols, opts)
                vim.keymap.set("n", "<leader>fw", fzf.lsp_workspace_symbols, opts)
                vim.keymap.set("n", "<leader>fi", fzf.lsp_implementations, opts)

                -- Acciones de código y refactorización
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

                -- Diagnósticos
                vim.keymap.set("n", "<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, opts)
                vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, opts)
                vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, opts)
                vim.keymap.set("n", "<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, opts)

                -- Auto-organizar imports
                if client:supports_method("textDocument/codeAction", bufnr) then
                    vim.keymap.set("n", "<leader>oi", function()
                        vim.lsp.buf.code_action({
                            context = { only = { "source.organizeImports" }, diagnostics = {} },
                            apply = true,
                            bufnr = bufnr,
                        })
                        vim.defer_fn(function() vim.lsp.buf.format({ bufnr = bufnr }) end, 50)
                    end, opts)
                end
            end

            -- Autocommand para asignar las teclas al abrir un archivo compatible
            local lsp_group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", { group = lsp_group, callback = lsp_on_attach })
            -- Atajos globales de diagnóstico
            vim.keymap.set("n", "<leader>q", function() vim.diagnostic.setloclist({ open = true }) end, { desc = "Open diagnostic list" })
            vim.keymap.set("n", "<leader>dl", vim.diagnostic.open_float, { desc = "Show line diagnostics" })

            -- ----------------------------------------------------------------------
            -- Inicialización de Servidores LSP
            -- ----------------------------------------------------------------------
            vim.lsp.config["*"] = { capabilities = capabilities }
            vim.lsp.config("pyright", {})
            vim.lsp.config("clangd", {})
            vim.lsp.config("jdtls", {})
            vim.lsp.config("hls", {})
            vim.lsp.config("texlab", {})
            vim.lsp.config("jsonls", {})
            vim.lsp.config("lua_ls", {
                settings = { Lua = { diagnostics = { globals = { "vim" } }, telemetry = { enable = false } } },
            })

            -- ----------------------------------------------------------------------
            -- Inicialización de EFM (Formatters y Linters)
            -- ----------------------------------------------------------------------
            local stylua = require("efmls-configs.formatters.stylua")
            local flake8 = require("efmls-configs.linters.flake8")
            local black = require("efmls-configs.formatters.black")
            local fixjson = require("efmls-configs.formatters.fixjson")
            local cpplint = require("efmls-configs.linters.cpplint")
            local clangfmt = require("efmls-configs.formatters.clang_format")

            vim.lsp.config("efm", {
                filetypes = {
                    "c", "cpp", "python", "json", "jsonc", "lua"
                },
                init_options = { documentFormatting = true },
                settings = {
                    languages = {
                        c = { clangfmt, cpplint },
                        cpp = { clangfmt, cpplint },
                        python = { flake8, black },
                        json = { fixjson },
                        jsonc = { fixjson },
                        lua = { stylua },
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
                "efm",
            })
        end,
    },
}

