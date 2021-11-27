--
-- KEY MAPS
--

--
-- Shortcuts
-- 

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

--
-- General
--

-- Skip shift
nvim_set_keymap("n", ";", ":", opts.nore)

-- Quick swap
nvim_set_keymap("n", "<Leader><Leader>", "<C-^>", opts.nore)

-- Save and keep (ZZ to save and quit, ZQ to quit without save)
nvim_set_keymap("n", "ZA", "<Cmd>w<CR>", opts.nore)

-- Delete to last change/delete register instead of overwriting yanked text 
nvim_set_keymap("n", "d", '""d', opts.nore)
nvim_set_keymap("n", "D", '""D', opts.nore)
nvim_set_keymap("n", "x", '""x', opts.nore)
nvim_set_keymap("n", "X", '""X', opts.nore)

-- Reload config or source files
nvim_set_keymap("n", "<Leader>rr", "<Cmd>Reload<CR>", opts.nore) -- Reload configuration
nvim_set_keymap("n", "<Leader>rR", "<Cmd>Restart<CR>", opts.nore) -- Reload and trigger VimEnter
nvim_set_keymap("n", "<Leader>rs", "<Cmd>source %<CR>", opts.nore) -- Source current file
nvim_set_keymap("n", "<Leader>rl", "<Cmd>luafile %<CR>", opts.nore) -- Source current Lua file

-- Move by softwrapped lines unless operator pending
nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", opts.noreExpr)
nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", opts.noreExpr)

--
-- Change
--

-- Sort selection
nvim_set_keymap("v", "<Leader>cS", ":sort!<CR>", opts.nore)
nvim_set_keymap("v", "<Leader>cs", ":sort<CR>", opts.nore)

--
-- Yank and put
--

-- Semantic register keys
nvim_set_keymap("n", '"s', '"*', opts.nore) -- Selection register (my default)
nvim_set_keymap("n", '"c', '"+', opts.nore) -- Clipboard register
nvim_set_keymap("n", '"d', '""', opts.nore) -- Delete register
nvim_set_keymap("n", '"t', '"t', opts.nore) -- Trash register

--
-- Lines
--

-- Insert new line and toggle comment (i.e., exit or begin comment block)
nvim_set_keymap("i", "<C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment()<CR>", opts.re)
nvim_set_keymap("i", "<S-C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment({above=true})<CR>", opts.re)
nvim_set_keymap("n", "<C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment()<CR>", opts.re)
nvim_set_keymap("n", "<S-C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment({above=true})<CR>", opts.re)

-- Duplicate line
nvim_set_keymap("i", "<S-CR>", '<Esc>yypA', opts.nore) -- Shift-Enter to duplicate in insert mode
nvim_set_keymap("n", "<S-CR>", 'yyp$', opts.nore) -- Shift-Enter to duplicate in insert mode
nvim_set_keymap("n", "<Leader>ld", 'yyp$', opts.nore) -- Leader-l-d => Line -> Duplicate
nvim_set_keymap("n", "<Leader>lD", 'yyP$', opts.nore) -- Leader-l-D => Line -> Duplicate backwards

-- Move lines and reindent
nvim_set_keymap("n", "<C-K>", "<Cmd>m-2<CR>==", opts.nore)
nvim_set_keymap("n", "<C-J>", "<Cmd>m+<CR>==", opts.nore)
nvim_set_keymap("v", "<C-K>", ":m'<-2<CR>gv=gv", opts.nore)
nvim_set_keymap("v", "<C-J>", ":m'>+<CR>gv=gv", opts.nore)

--
-- Insert mode
--

-- Navigate text
nvim_set_keymap("i", "<C-h>", "<Left>", opts.nore)
nvim_set_keymap("i", "<C-j>", "<Down>", opts.nore)
nvim_set_keymap("i", "<C-k>", "<Up>", opts.nore)
nvim_set_keymap("i", "<C-l>", "<Right>", opts.nore)

--
-- Command mode
--

-- Navigate text
nvim_set_keymap("c", "<C-a>", "<Home>", opts.nore)
nvim_set_keymap("c", "<C-e>", "<End>", opts.nore)
nvim_set_keymap("c", "<C-f>", "<Right>", opts.nore)
nvim_set_keymap("c", "<C-b>", "<Left>", opts.nore)
nvim_set_keymap("c", "<C-u>", "<End><C-u>", opts.nore)
nvim_set_keymap("c", "<C-k>", "repeat('<Del>', strchars(getcmdline()[getcmdpos() - 1:]))", opts.noreExpr)

-- Modify input
nvim_set_keymap("c", "<M-i>", "<Home>lua print(vim.inspect(<End>))", opts.nore) -- Wrap with inspect
nvim_set_keymap("c", "<M-l>", "<Home>lua <End>", opts.nore) -- Prepend lua
nvim_set_keymap("c", "<M-f>", "expand('%')", opts.noreExpr) -- Insert current file path

-- Prefill input
nvim_set_keymap("n", "<Leader>li", ":lua print(vim.inspect())<Left><Left>", opts.nore)
nvim_set_keymap("n", "<Leader>ll", ":lua ", opts.nore)
nvim_set_keymap("n", "<Leader>gh", ":help ", opts.nore)

--
-- Toggle
--

-- Explorer
nvim_set_keymap("n", "<Leader>te", "<Cmd>Lex<CR>", opts.nore)

-- Highlights
nvim_set_keymap("n", "<Leader>th", "<Cmd>set hlsearch!<CR>", opts.nore)
nvim_set_keymap("n", "<Esc>", "<Cmd>set nohlsearch<CR>", opts.nore)

-- Spelling
nvim_set_keymap("n", "<Leader>ts", "<Cmd>set spell!<CR>", opts.nore)

--
-- Find
--

-- Fuzzy find
nvim_set_keymap("n", "<C-Space>", "<Cmd>FzfLua<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fC", "<Cmd>FzfLua colorschemes<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fc", "<Cmd>FzfLua commands<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>ff", "<Cmd>FzfLua files<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fg", "<Cmd>FzfLua live_grep<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fm", "<Cmd>FzfLua marks<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>ft", "<Cmd>FzfLua tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fz", "<Cmd>FzfLua<CR>", opts.nore)

-- List buffers
nvim_set_keymap("n", "gb", "<Cmd>ls<CR>:b<Space>", opts.nore)

--
-- Language and project
--

-- Renamer
nvim_set_keymap('i', '<F2>', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('n', '<F2>', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('n', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('v', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)

-- LSP and diagnostics
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

--
-- Custom operators
--

-- Go search (pending operator)
nvim_set_keymap("n", "<Leader>gs", "<Cmd>lua NORDUtils.operators.browsersearch()<CR>", opts.nore)

