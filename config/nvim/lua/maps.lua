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
  nore = {noremap = true},
  noreExpr = {noremap = true, expr = true},
  noreSilent = {noremap = true, silent = true},
  noreSilentExpr = {noremap = true, silent = true, expr = true},
  silent = {silent = true}
}

-- Reload config

nvim_set_keymap("n", "<Leader>rr", "<Cmd>lua NORDUtils.reload(true)<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>rR", "<Cmd>lua NORDUtils.reload(false)<CR>", opts.nore)

-- Save

nvim_set_keymap("n", "ZW", "<Cmd>w<CR>", opts.nore)

-- Insert mode navigation

nvim_set_keymap("i", "<C-h>", "<Left>", opts.nore)
nvim_set_keymap("i", "<C-j>", "<Down>", opts.nore)
nvim_set_keymap("i", "<C-k>", "<Up>", opts.nore)
nvim_set_keymap("i", "<C-l>", "<Right>", opts.nore)

-- Move by line even when soft wrapped

nvim_set_keymap("n", "j", "gj", opts.nore)
nvim_set_keymap("n", "k", "gk", opts.nore)

-- Command mode navigation

nvim_set_keymap("c", "<C-a>", "<Home>", opts.nore)
nvim_set_keymap("c", "<C-e>", "<End>", opts.nore)
nvim_set_keymap("c", "<C-f>", "<Right>", opts.nore)
nvim_set_keymap("c", "<C-b>", "<Left>", opts.nore)
nvim_set_keymap("c", "<C-u>", "<End><C-u>", opts.nore)
nvim_set_keymap("c", "<M-l>", "<Home>lua print(vim.inspect(<End>))", opts.nore)

nvim_set_keymap("n", "<Leader>vi", ":lua print(vim.inspect())<Left><Left>", opts.nore)
nvim_set_keymap("n", "<Leader>vl", ":lua ", opts.nore)
nvim_set_keymap("n", "<Leader>vh", "<Cmd>help ", opts.nore)

-- Toggle netrw

nvim_set_keymap("n", "<C-b>", "<Cmd>Lex<CR>", opts.nore)

-- Clear search highlights

nvim_set_keymap("n", "<Leader>h", "<Cmd>set hlsearch!<CR>", opts.nore)

-- Go to buffer

nvim_set_keymap("n", "gb", "<Cmd>ls<CR>:b<Space>", opts.nore)

-- FZF

nvim_set_keymap("n", "<Leader>ff", "<Cmd>FzfLua files<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fg", "<Cmd>FzfLua grep<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fl", "<Cmd>FzfLua live_grep<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>ft", "<Cmd>FzfLua tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fm", "<Cmd>FzfLua marks<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fc", "<Cmd>FzfLua commands<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fz", "<Cmd>FzfLua<CR>", opts.nore)

-- Custom operators

nvim_set_keymap("n", "<Leader>gs", "<Cmd>lua NORDUtils.operators.browsersearch()<CR>", opts.nore)

-- Renamer

nvim_set_keymap('i', '<F2>', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('n', '<F2>', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('n', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('v', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)

-- Diagnostic (called when attaching language server)

nvim_buf_set_keymap(bufnr, "n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "n", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "i", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "n", "<Leader>dN", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "n", "<Leader>dn", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "n", "<Leader>dl", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "n", "<Leader>dd", "<Cmd>TroubleToggle<CR>", opts.nore)
nvim_buf_set_keymap(bufnr, "n", "<Leader>do", ":TSLspOrganize<CR>", opts.silent)
nvim_buf_set_keymap(bufnr, "n", "<Leader>dr", ":TSLspRenameFile<CR>", opts.silent)
nvim_buf_set_keymap(bufnr, "n", "<Leader>di", ":TSLspImportAll<CR>", opts.silent)
nvim_buf_set_keymap(bufnr, "n", "<Leader>df", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts.silent)
nvim_buf_set_keymap(bufnr, "n", "<Leader>dF", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts.silent)

