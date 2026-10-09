return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = "FzfLua",
    keys = {
        { "<leader>ff", "<cmd>FzfLua files<cr>",           desc = "Buscar Archivos (fzf)" },
        { "<leader>fg", "<cmd>FzfLua live_grep<cr>",       desc = "Live Grep (fzf)" },
        { "<leader>fz", "<cmd>FzfLua blines<cr>",          desc = "Archive grep (fzf)" },
        { "<leader>fb", "<cmd>FzfLua buffers<cr>",         desc = "Buscar Buffers (fzf)" },
        { "<leader>fh", "<cmd>FzfLua help_tags<cr>",       desc = "Ayuda Neovim (fzf)" },
        { "<leader>fc", "<cmd>FzfLua command_history<cr>", desc = "Historial Comandos (fzf)" },
    },
    init = function()
        -- Usa fzf-lua para vim.ui.select (sustituye a dressing.nvim) sin cargarlo al inicio
        ---@diagnostic disable-next-line: duplicate-set-field
        vim.ui.select = function(...)
            require("fzf-lua").register_ui_select()
            return vim.ui.select(...)
        end
    end,
    opts = {
        "telescope",
        winopts = {
            height = 0.60,
            width = 0.70,
            border = "rounded",
            preview = {
                default = "builtin",
                border = "rounded",
                layout = "horizontal",
                horizontal = "right:50%",
                scrollbar = false,
            }
        },
    },
}
