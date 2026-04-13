return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
        local harpoon = require("harpoon")
        harpoon:setup()
        local keymap = vim.keymap
        keymap.set("n", "<leader>a", function() harpoon:list():add() end, { desc = "Harpoon: Marcar archivo" })
        -- Se elimina de la lista con "dd"
        keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon: Ver menu" })
        keymap.set("n", "<leader>h", function() harpoon:list():select(1) end)
        keymap.set("n", "<leader>j", function() harpoon:list():select(2) end)
        keymap.set("n", "<leader>k", function() harpoon:list():select(3) end)
        keymap.set("n", "<leader>l", function() harpoon:list():select(4) end)
    end,
}

