vim.g.mapleader      = " "
vim.g.maplocalleader = " "

local o = vim.opt

o.number         = true
o.relativenumber = true
o.signcolumn     = "yes"
o.cursorline     = true

o.expandtab  = true
o.shiftwidth = 2
o.tabstop    = 2
o.smartindent = true

o.wrap       = false
o.scrolloff  = 8
o.sidescrolloff = 8

o.ignorecase = true
o.smartcase  = true
o.hlsearch   = false
o.incsearch  = true

o.termguicolors = true
o.background    = "dark"

o.undofile   = true
o.swapfile   = false
o.backup     = false

o.splitbelow = true
o.splitright = true

o.updatetime   = 250
o.timeoutlen   = 400
o.completeopt  = { "menuone", "noselect" }

o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
