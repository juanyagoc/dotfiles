return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-treesitter.configs").setup({
      ensure_installed = {
        "c",
        "cpp",
        "python",
        "java",
        "haskell",
        "json",
        "jsonc",
        "lua",
        "vim",
        "vimdoc",
        "markdown",
        "markdown_inline",
        "bash",
      },
      auto_install = true,

      highlight = {
        enable = true,
        disable = { "latex", "tex" },
        additional_vim_regex_highlighting = false,
      },
      indent = {
        enable = true,
        disable = {},
      },
    })
  end,
}

