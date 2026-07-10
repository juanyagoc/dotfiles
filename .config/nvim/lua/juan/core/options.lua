-- ~/.config/nvim/lua/juan/core/options.lua
-- general nvim options configuration file

local opt = vim.opt

opt.number = true         -- show the line numbers
opt.relativenumber = true -- relative line numbering
opt.numberwidth = 1

-- tabs & indentation
opt.tabstop = 4       -- 4 spaces for tabs (prettier default)
opt.shiftwidth = 4    -- 4 spaces for indent width
opt.expandtab = true  -- expand tab to spaces
opt.smartindent = true
opt.cindent = true
opt.autoindent = true -- copy indent from current line when starting new one

opt.wrap = true        -- wrap the line below if its too long for the window
opt.linebreak = true   -- use the spaces between words to wrap the line so it doest break words apart
opt.breakindent = true -- maintain the indentation when wraping the line 

opt.laststatus = 3     -- global status line

-- search settings
opt.ignorecase = true  -- ignore case when searching
opt.smartcase = true   -- if you include mixed case in your search, assumes you want case-sensitive

opt.cursorline = false -- highlight the line youre at

-- turn on termguicolors for kanagawa colorscheme to work
-- (have to use iterm2, alacritty or any other true color terminal)
opt.termguicolors = true
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes"  -- show sign column so that text doesn't shift

opt.backspace = "indent,eol,start"  -- allow backspace on indent, end of line or insert mode start position

opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

opt.swapfile = false  -- turn off swapfile

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
opt.breakindent = true
opt.mouse = "a"   -- abilites the mouse for 'a'll interactions
opt.sidescrolloff = 8
opt.scrolloff = 5

