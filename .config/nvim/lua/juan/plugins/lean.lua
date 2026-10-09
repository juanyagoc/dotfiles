return {
    "Julian/lean.nvim",
    ft = "lean",
    dependencies = {
        "neovim/nvim-lspconfig",
        "nvim-lua/plenary.nvim",
        "ibhagwan/fzf-lua",
    },
    init = function()
        vim.g.lean_config = {
            mappings = true,
            infoview = {
                autoopen = true,
            },
            lsp = {
            },
        }
    end,
    config = function()
        -- <leader>L para no chocar con <leader>l (Harpoon 4)
        local map = vim.keymap.set
        map("n", "<leader>Li", "<Plug>(LeanInfoviewToggle)", { desc = "Lean: Toggle Infoview" })
        map("n", "<leader>Lg", function()
            require("fzf-lua").live_grep({
                search_paths = require("lean").current_search_paths(),
            })
        end, { desc = "Lean: Live Grep en librerías/Mathlib" })

        -- change hichglighting
        vim.api.nvim_set_hl(0, "@lsp.type.variable", { link = "Identifier" })
    end,
}
