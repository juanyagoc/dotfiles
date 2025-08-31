return {
	"lervag/vimtex",
	lazy = false, -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		-- VimTeX configuration
		vim.g.vimtex_view_method = 'skim'
        vim.g.vimtex_compiler_latexmk = {
          continuous = 1,
          options = {
            "-interaction=nonstopmode",
            "-synctex=1",
            "-pvc",
            "-pdf",
            "-view=none",
            "-quiet",
          },
        }

    -- Indentation settings
    vim.g.vimtex_indent_enabled = false            -- Disable auto-indent from Vimtex
    vim.g.tex_indent_items = true                  -- Disable indent for enumerate - currently enabled
    vim.g.tex_indent_brace = false                 -- Disable brace indent

    -- Suppression settings
    vim.g.vimtex_quickfix_mode = 0                 -- Suppress quickfix on save/build
    vim.g.vimtex_log_ignore = {                    -- Suppress specific log messages
      'Underfull',
      'Overfull',
      'specifier changed to',
      'Token not allowed in a PDF string',
    }

  -- Initiate compilation when a .tex is opened

	--	vim.api.nvim_create_autocmd("FileType", {
  --           pattern = "tex",
  --            callback = function()
  --            vim.cmd("VimtexCompile")
  --           end,
  --      })
	end,
}
