return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    dependencies = {
        "rafamadriz/friendly-snippets",
    },
    opts = {
        history = true,
        delete_check_events = "TextChanged",
        update_events = "TextChanged,TextChangedI",
        enable_autosnippets = true,
    },
    config = function(_, opts)
        local luasnip = require("luasnip")
        luasnip.config.set_config(opts)

        require("luasnip.loaders.from_vscode").lazy_load()

        require("luasnip.loaders.from_lua").lazy_load({
            paths = { vim.fn.stdpath("config") .. "/snippets" },
        })

        luasnip.filetype_extend("markdown", { "latex" })
    end,
}

