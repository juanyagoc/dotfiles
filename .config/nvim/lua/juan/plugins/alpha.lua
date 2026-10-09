return {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        local alpha = require("alpha")
        local startify = require("alpha.themes.startify")
        vim.api.nvim_set_hl(0, "AlphaBadge", { fg = "#7aa2f7", bold = true, italic = true })
        vim.api.nvim_set_hl(0, "OrcidLogo", { fg = "#A6CE39" })
        startify.section.header.opts.hl = {
            { { "StartifyHeader", 0, 50 } },
            { { "StartifyHeader", 0, 50 } },
            { { "StartifyHeader", 0, 50 } },
            { { "StartifyHeader", 0, 50 }, { "AlphaBadge", 50, 100 } },
            { { "StartifyHeader", 0, 50 } },
            { { "StartifyHeader", 0, 51 }, { "OrcidLogo", 51, 52 }, { "StartifyHeader", 52, 100 }},
        }
        startify.section.header.val = {
            [[                               __]],
            [[  ___     ___    ___   __  __ /\_\    ___ ___]],
            [[ / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
            [[/\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \   JUAN YAGO]],
            [[\ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\  @juanyagoc]],
            [[ \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/   0009-0007-3807-7854]],
        }

        startify.section.top_buttons.val = {
            startify.button("f", "Find files", ":FzfLua files <CR>"),
            startify.button("g", "Live grep", ":FzfLua live_grep <CR>"),
            startify.button("r", "Recent files", ":FzfLua oldfiles <CR>"),
        }

        -- startify.mru_opts.limit = 10
        alpha.setup(startify.config)
    end,
}
--return {
--    "goolord/alpha-nvim",
--    event = "VimEnter",
--    dependencies = { "nvim-tree/nvim-web-devicons" },
--    config = function()
--        local alpha = require("alpha")
--        local dashboard = require("alpha.themes.dashboard")
--        dashboard.section.header.val = {
--            [[                                  __]],
--            [[     ___     ___    ___   __  __ /\_\    ___ ___]],
--            [[    / _ `\  / __`\ / __`\/\ \/\ \\/\ \  / __` __`\]],
--            [[   /\ \/\ \/\  __//\ \_\ \ \ \_/ |\ \ \/\ \/\ \/\ \]],
--            [[   \ \_\ \_\ \____\ \____/\ \___/  \ \_\ \_\ \_\ \_\]],
--            [[    \/_/\/_/\/____/\/___/  \/__/    \/_/\/_/\/_/\/_/]],
--        }
--
--        dashboard.section.buttons.val = {
--            dashboard.button("e", "  > Nuevo archivo vacío", "<cmd>ene<CR>"),
--            dashboard.button("SPC ee", "  > Explorador de archivos", "<cmd>Neotree<CR>"),
--            dashboard.button("SPC ff", "󰱼  > Buscar archivo", "<cmd>FzfLua files<CR>"),
--            dashboard.button("SPC fg", "󰊄  > Buscar texto (Grep)", "<cmd>FzfLua live_grep<CR>"),
--            dashboard.button("SPC r", "  > Archivos recientes", "<cmd>FzfLua oldfiles<CR>"),
--            dashboard.button("SPC wr", "󰁯  > Restaurar Sesión", "<cmd>AutoSession restore<CR>"),
--            dashboard.button("a", "󰙨  > Teoría de Autómatas", "<cmd>cd ~/Proyectos/number-of-strings | Neotree<CR>"),
--            dashboard.button("c", "  > Programación Competitiva", "<cmd>cd ~/Proyectos/cp/code-forces/contests | Neotree<CR>"),
--            dashboard.button("q", "  > Salir", "<cmd>qa<CR>"),
--        }
--
--        dashboard.config.layout = {
--            { type = "padding", val = 2 },
--            dashboard.section.header,
--            { type = "padding", val = 2 },
--            dashboard.section.buttons,
--            { type = "padding", val = 1 },
--            dashboard.section.footer,
--        }
--
--        alpha.setup(dashboard.config)
--        vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
--    end,
--}
--
