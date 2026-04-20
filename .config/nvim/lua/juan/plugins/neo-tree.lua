return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
            close_if_last_window = true,
            enable_git_status = true,
            enable_diagnostics = true,
            filesystem = {
                filtered_items = {
                    visible = false,
                    hide_dotfiles = false,
                    hide_gitignored = false,
                    never_show = {
                        ".DS_Store",
                    },
                },
            },
            default_component_configs = {
                indent = {
                    with_markers = true,
                    indent_marker = "│",
                    last_indent_marker = "└",
                },
                icon = {
                    folder_closed = "",
                    folder_open = "",
                    folder_empty = "",
                },
                git_status = {
                    symbols = {
                        added     = "✚",
                        modified  = "",
                        deleted   = "✖",
                        renamed   = "󰁕",
                        untracked = "",
                        ignored   = "",
                        unstaged  = "󰄱",
                        staged    = "",
                        conflict  = "",
                    }
                },
            },
            window = {
                position = "left",
                width = 30,
                mapping_options = { noremap = true, nowait = true },
                mappings = {
                    ["<space>"] = { "toggle_node", nowait = false },
                    ["<2-LeftMouse>"] = "open",
                    ["<cr>"] = "open",
                    ["ESC"] = "cancel",
                    ["q"] = "close_window",
                }
            },
        })
        local map = vim.keymap.set
        map("n", "<leader>ee", "<cmd>Neotree toggle<CR>", { desc = "Explorador (Lateral)" })
        map("n", "<leader>ef", "<cmd>Neotree float toggle<CR>", { desc = "Explorador (Flotante)" })
        map("n", "<leader>eg", "<cmd>Neotree float git_status<CR>", { desc = "Explorador (Git)" })
    end
}
