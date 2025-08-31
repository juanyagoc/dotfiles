return {
  "kylechui/nvim-surround",
  event = { "BufReadPre", "BufNewFile" },
  version = "^3.0.0",
  config = function()
    require("nvim-surround").setup({
      -- add config
    })
  end
}
