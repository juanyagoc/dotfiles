return {
    "lervag/vimtex",
    lazy = false, -- VimTeX ya carga perezosamente por dentro
    init = function()
        vim.g.vimtex_view_method = "sioyek"
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_quickfix_ignore_filters = {
            "Underfull", "Overfull"
        }

        vim.g.vimtex_indent_enabled = false

        vim.api.nvim_create_autocmd("User", {
            group = vim.api.nvim_create_augroup("juan_vimtex", { clear = true }),
            pattern = "VimtexEventInitPost",
            command = "VimtexCompile",
        })
        vim.opt.conceallevel = 2
        -- "nc" significa que el texto se oculta en modo normal y command.
        -- vim.opt.concealcursor = "nc"
        -- vim.g.tex_conceal = "abdmg"
        vim.g.vimtex_syntax_conceal = {
            accents = 1,
            ligatures = 1,
            cites = 1,
            fancy = 1,
            spacing = 1,
            math_bounds = 1,
            math_delimiters = 1,
            math_fracs = 1,
            math_super_sub = 1,
            math_symbols = 1,
            sections = 0,
            styles = 1,
        }
    end,
}
