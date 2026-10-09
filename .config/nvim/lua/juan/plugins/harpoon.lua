local function harpoon_list()
    return require("harpoon"):list()
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
        { "<leader>a", function() harpoon_list():add() end, desc = "Harpoon: Marcar archivo" },
        -- Se elimina de la lista con "dd"
        {
            "<C-e>",
            function()
                require("harpoon").ui:toggle_quick_menu(harpoon_list(), {
                    border = "rounded",
                    title_pos = "center",
                    title = " Harpoon ",
                    ui_width_ratio = 0.40,
                })
            end,
            desc = "Harpoon: Ver menu",
        },
        { "<leader>h", function() harpoon_list():select(1) end, desc = "Harpoon: Archivo 1" },
        { "<leader>j", function() harpoon_list():select(2) end, desc = "Harpoon: Archivo 2" },
        { "<leader>k", function() harpoon_list():select(3) end, desc = "Harpoon: Archivo 3" },
        { "<leader>l", function() harpoon_list():select(4) end, desc = "Harpoon: Archivo 4" },
    },
    config = function()
        require("harpoon"):setup()
    end,
}
