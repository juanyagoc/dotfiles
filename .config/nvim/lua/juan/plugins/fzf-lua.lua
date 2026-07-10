return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local fzf = require("fzf-lua")
        fzf.setup({
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
            --[[fzf_opts = {
                ["--layout"] = "reverse",
                ["--info"] = "inline",
                ["--border"] = "none",
                ["--margin"] = "0",
                ["--padding"] = "0",
            }]]--
        })
        local map = vim.keymap.set
        map("n", "<leader>ff", function() fzf.files() end, { desc = "Buscar Archivos (fzf)" })
        map("n", "<leader>fg", function() fzf.live_grep() end, { desc = "Live Grep (fzf)" })
        map("n", "<leader>fb", function() fzf.buffers() end, { desc = "Buscar Buffers (fzf)" })
        map("n", "<leader>fh", function() fzf.help_tags() end, { desc = "Ayuda Neovim (fzf)" })
        map("n", "<leader>fc", function() fzf.command_history() end, { desc = "Historial Comandos (fzf)" })
    end
}

