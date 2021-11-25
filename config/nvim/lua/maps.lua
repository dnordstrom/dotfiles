--
-- Maps
--

-- Shortcuts

local g = vim.g
local fn = vim.fn
local api = vim.api
local opt = vim.opt
local opt_local = vim.opt_local
local opt_global = vim.opt_global
local nvim_exec = vim.api.nvim_exec
local nvim_set_keymap = vim.api.nvim_set_keymap
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
local opts = {
  re = {},
  nore = {noremap = true},
  noreExpr = {noremap = true, expr = true},
  noreSilent = {noremap = true, silent = true},
  noreSilentExpr = {noremap = true, silent = true, expr = true},
  silent = {silent = true}
}

-- General

nvim_set_keymap("n", ";", ":", opts.nore)
nvim_set_keymap("n", "<Leader><Leader>", "<C-^>", opts.nore)
nvim_set_keymap("n", "<C-Space>", "<Cmd>FzfLua<CR>", opts.nore)
nvim_set_keymap("v", "<Leader>cS", ":sort!<CR>", opts.nore)
nvim_set_keymap("v", "<Leader>cs", ":sort<CR>", opts.nore)

-- Don't yank to regular register on deletes
nvim_set_keymap("n", "d", '"0d', opts.nore)
nvim_set_keymap("n", "D", '"0D', opts.nore)
nvim_set_keymap("n", "x", '"0x', opts.nore)
nvim_set_keymap("n", "X", '"0X', opts.nore)

-- Reload

nvim_set_keymap("n", "<Leader>rR", "<Cmd>lua NORDUtils.reload({live = false})<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>rr", "<Cmd>lua NORDUtils.reload({live = true})<CR>", opts.nore)

-- Save

nvim_set_keymap("n", "ZA", "<Cmd>w<CR>", opts.nore)

-- Paste

-- Paste from system clipboard
nvim_set_keymap("n", "<Leader>p", '<Cmd>"+p<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>P", '<Cmd>"+P<CR>', opts.nore)

-- Yank

-- New line with toggled comment (if on a comment line, inserts non-comment line, and nice versa),
-- using <Plug> to avoid problems with which-key.
nvim_set_keymap("i", "<C-CR>", '<Esc>^o<Esc>gcci', opts.re)
nvim_set_keymap("n", "<C-CR>", '^o<Esc>gcci', opts.re)

-- Duplicates current line
nvim_set_keymap("i", "<S-CR>", '<Esc>yypA', opts.nore)
nvim_set_keymap("n", "<S-CR>", 'yyp$', opts.nore)

-- Insert mode navigation

nvim_set_keymap("i", "<C-h>", "<Left>", opts.nore)
nvim_set_keymap("i", "<C-j>", "<Down>", opts.nore)
nvim_set_keymap("i", "<C-k>", "<Up>", opts.nore)
nvim_set_keymap("i", "<C-l>", "<Right>", opts.nore)

-- Move by line even when wrapped unless in operator pending mode

nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", opts.noreExpr)
nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", opts.noreExpr)

-- Shell/Emacs-like command mode navigation and Alt key shortcuts

nvim_set_keymap("c", "<C-a>", "<Home>", opts.nore)
nvim_set_keymap("c", "<C-e>", "<End>", opts.nore)
nvim_set_keymap("c", "<C-f>", "<Right>", opts.nore)
nvim_set_keymap("c", "<C-b>", "<Left>", opts.nore)
nvim_set_keymap("c", "<C-u>", "<End><C-u>", opts.nore)
nvim_set_keymap("c", "<C-k>", "repeat('<Del>', strchars(getcmdline()[getcmdpos() - 1:]))", opts.noreExpr)

nvim_set_keymap("c", "<M-l>", "<Home>lua print(vim.inspect(<End>))", opts.nore)
nvim_set_keymap("c", "<M-f>", "expand('%')", opts.noreExpr)

nvim_set_keymap("n", "<Leader>li", ":lua print(vim.inspect())<Left><Left>", opts.nore)
nvim_set_keymap("n", "<Leader>ll", ":lua ", opts.nore)

nvim_set_keymap("n", "<Leader>gh", ":help ", opts.nore)

-- Toggle netrw

nvim_set_keymap("n", "<C-b>", "<Cmd>Lex<CR>", opts.nore)

-- Clear search highlights

nvim_set_keymap("n", "<Leader>th", "<Cmd>set hlsearch!<CR>", opts.nore)
nvim_set_keymap("n", "<Esc>", "<Cmd>set nohlsearch<CR>", opts.nore)

-- Go to buffer

nvim_set_keymap("n", "gb", "<Cmd>ls<CR>:b<Space>", opts.nore)

-- FZF

nvim_set_keymap("n", "<Leader>fC", "<Cmd>FzfLua colorschemes<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fc", "<Cmd>FzfLua commands<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>ff", "<Cmd>FzfLua files<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fg", "<Cmd>FzfLua live_grep<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fm", "<Cmd>FzfLua marks<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>ft", "<Cmd>FzfLua tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fz", "<Cmd>FzfLua<CR>", opts.nore)

-- Custom operators

nvim_set_keymap("n", "<Leader>gs", "<Cmd>lua NORDUtils.operators.browsersearch()<CR>", opts.nore)

-- Renamer

nvim_set_keymap('i', '<F2>', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('n', '<F2>', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('n', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('v', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)

-- Diagnostic (called when attaching language server)

nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts.nore)
nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("i", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dN", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dn", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dl", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dd", "<Cmd>TroubleToggle<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>do", ":TSLspOrganize<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>dr", ":TSLspRenameFile<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>di", ":TSLspImportAll<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>df", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>dF", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts.silent)

