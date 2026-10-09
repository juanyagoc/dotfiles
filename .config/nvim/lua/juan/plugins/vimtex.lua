return {
    "lervag/vimtex",
    lazy = false, -- si no, falla la búsqueda inversa (VimTeX ya carga perezosamente por dentro)
    init = function()
        vim.g.vimtex_view_method = "sioyek"
        vim.g.vimtex_quickfix_mode = 2
        vim.g.vimtex_quickfix_open_on_warning = 0
        vim.g.vimtex_quickfix_ignore_filters = {
            "Underfull", "Overfull", "specifier changed to",
            "Token not allowed in a PDF string",
        }

        vim.g.vimtex_indent_enabled = false

        vim.api.nvim_create_autocmd("User", {
            group = vim.api.nvim_create_augroup("juan_vimtex", { clear = true }),
            pattern = "VimtexEventInitPost",
            command = "VimtexCompile",
        })
    end,
}
