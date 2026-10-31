return {
    "Saghen/blink.cmp",
    opts = {
        snippets = {
            preset = "luasnip",
        },
        keymap = {
            preset = "default",
            ["<C-j>"] = { "snippet_forward", "fallback" },
            ["<C-k>"] = { "snippet_backward", "fallback" },
        },
    },
}

