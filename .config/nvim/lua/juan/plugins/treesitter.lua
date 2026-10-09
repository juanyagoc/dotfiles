return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false, -- la rama main no admite lazy loading (y es ligera)
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "c_sharp",
      "asm",
      "json",
      "yaml",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "python",
      "java",
      "haskell",
      "sql",
    })

    -- resaltado e indentación con treesitter cuando haya parser
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("juan_treesitter", { clear = true }),
      callback = function(ev)
        if ev.match == "tex" then return end -- mejor coloreado con VimTeX
        if pcall(vim.treesitter.start, ev.buf) then
          vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}
