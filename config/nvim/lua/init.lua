-- Shortcuts

local g = vim.g
local o = vim.opt

-- Settings

g.mapleader = ','

o.backup = false
o.writebackup = false
o.ignorecase = true
o.number = true
o.relativenumber = true
o.swapfile = false

-- Formatting

o.autoindent = true
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

-- Language Servers

lspconfig = require'lspconfig'
lspconfig.denols.setup{}
lspconfig.html.setup{}

-- Key Binds

---- Clear search highlights
vim.api.nvim_set_keymap('n', '<Leader><Space>', ':set hlsearch!<CR>', { noremap = true, silent = true })

---- Go to buffer
vim.api.nvim_set_keymap('n', 'gb', ':ls<CR>:b<Space>', { noremap = true, silent = true })