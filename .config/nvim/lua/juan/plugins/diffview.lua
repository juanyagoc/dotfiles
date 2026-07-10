return {
  {
    "sindrets/diffview.nvim",
    dependencies = "nvim-tree/nvim-web-devicons", -- Para iconos bonitos
    cmd = { "DiffviewOpen", "DiffviewFileHistory" }, -- Carga perezosa
    keys = {
      { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Abrir Git Diffview" },
      { "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "Historial del archivo actual" },
    },
    config = function()
      require("diffview").setup({
        enhanced_diff_hl = true, -- Mejora el resaltado de sintaxis en los diffs
        view = {
          merge_tool = {
            layout = "diff3_mixed",
          },
        },
      })
    end,
  }
}

