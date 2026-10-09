return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    init = function()
        -- netrw está desactivado: abrir neo-tree si se arranca con `nvim <carpeta>`
        vim.api.nvim_create_autocmd("BufEnter", {
            group = vim.api.nvim_create_augroup("juan_neotree_start_directory", { clear = true }),
            once = true,
            callback = function()
                if package.loaded["neo-tree"] then return end
                local stats = vim.uv.fs_stat(vim.fn.argv(0))
                if stats and stats.type == "directory" then
                    require("neo-tree")
                end
            end,
        })
    end,
    keys = {
        { "<leader>ee", "<cmd>Neotree toggle<CR>", desc = "Explorador (Lateral)" },
        { "<leader>ef", "<cmd>Neotree float toggle<CR>", desc = "Explorador (Flotante)" },
        { "<leader>eg", "<cmd>Neotree float git_status<CR>", desc = "Explorador (Git)" },
    },
    opts = {
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
                ["<esc>"] = "cancel",
                ["q"] = "close_window",
            }
        },
    },
}
