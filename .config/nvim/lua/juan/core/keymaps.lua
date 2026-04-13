-- ~/.config/nvim/lua/juan/core/keymaps.lua
-- general nvim keymaps definition file
vim.g.mapleader = " " -- I use the 'space' key as the map leader

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>",       { desc = "Exit insert mode with jk"           })
keymap.set("n", "nh", ":nohl<CR>",   { desc = "Delete work search highlighting nh" })
keymap.set("n", "vs", ":vsplit<CR>", { desc = "Do a vertical split of nvim"        })
keymap.set("n", "vh", ":split<CR>",  { desc = "Do a horizontal split of nvim"      })

