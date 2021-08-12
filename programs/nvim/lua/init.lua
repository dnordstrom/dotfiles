-- Shortcuts

local g = vim.g
local.o = vim.opt

-- Settings

g.mapleader = ','

o.backup = 'nowritebackup'
o.number = true
o.relativenumber = true
o.ignorecase = true
o.swapfile = false

-- Formatting

o.tabstop = 2
o.softtabstop = 2
o.expandtab = true
o.shiftwidth=2
o.autoindent = true

-- Language Servers

lspconfig = require'lspconfig'
lspconfig.html.setup{}
lspconfig.denols.setup{}

"
" Key Binds
"

" Clear search highlight
nnoremap <silent> <C-l>:nohlsearch<CR><C-l>
" Go to buffer
nnoremap gb :ls<cr>:b<space>