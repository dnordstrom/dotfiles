--
-- KEY MAPS
--
-- Notes:
--
--   - `nvim_set_keymap("", ...)` maps normal, visual, and operator pending mode
--   - `nvim_set_keymap("!", ...)` maps command and insert mode
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
	-- "Regular"
	re = {},
	expr = { expr = true },
	silent = { silent = true },
	silentExpr = { silent = true, expr = true },

	-- Non-recursive
	nore = { noremap = true },
	noreExpr = { noremap = true, expr = true },
	noreSilent = { noremap = true, silent = true },
	noreSilentExpr = { noremap = true, silent = true, expr = true },

	-- Other
	nowait = { nowait = true },
}

-- Adds an abbreviation, by default prefixed with comma
local abbreviate = function(lhs, rhs, options)
	options = options or {}

	expr = options.expr and " <expr> " or " "
	prefix = options.prefix or ";"
	suffix = options.suffix or ";"
	command = "abbreviate" .. expr .. prefix .. lhs .. suffix .. " " .. rhs

	nvim_exec(command, false)
end

--
-- Convenient...
--

-- ...command mode
nvim_set_keymap("n", ";", ":", opts.nore)

-- ...window switch
nvim_set_keymap("n", "<Tab>", "<Cmd>wincmd w<CR>", opts.nore)

-- ...buffer switch
nvim_set_keymap("n", "<Leader><Leader>", "<C-^>", opts.nore)

-- ...indent
nvim_set_keymap("v", "<Tab>", ">gv", opts.nore)
nvim_set_keymap("v", "<S-Tab>", "<gv", opts.nore)

-- ...highlight toggle (one press optimal but annoys incurable key spammers, can personally confirm)
nvim_set_keymap("n", "<Esc><Esc>", "<Cmd>set hlsearch!<CR>", opts.nore)

-- ...find
nvim_set_keymap("n", "<C-Space>", "<Cmd>FzfLua<CR>", opts.nore)

-- ...semantic register keys (regardless of shift key)
nvim_set_keymap("n", '"s', '"*', opts.nore) -- Selection
nvim_set_keymap("n", '"S', '"*', opts.nore) -- Selection
nvim_set_keymap("n", '"c', '"+', opts.nore) -- Clipboard
nvim_set_keymap("n", '"C', '"+', opts.nore) -- Clipboard
nvim_set_keymap("n", '"d', '""', opts.nore) -- Delete
nvim_set_keymap("n", '"D', '""', opts.nore) -- Delete
nvim_set_keymap("n", '"t', '"t', opts.nore) -- Throw-away
nvim_set_keymap("n", '"T', '"t', opts.nore) -- Throw-away

-- ...window splits
nvim_set_keymap("n", "<Leader>-", ":split | wincmd j<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>|", ":vsplit | wincmd l<CR>", opts.nore)

--
-- Compliment defaults with...
--

-- ...save and keep (ZZ, ZQ)
nvim_set_keymap("n", "ZA", "<Cmd>w<CR>", opts.nore)
nvim_set_keymap("i", "ZA", "<Cmd>w<CR>", opts.nore)

--
-- Modify defaults to...
--

-- ...change registers for delete and cut to not overwrite yanked content. Instead use the unnamed
-- register that already should contain the last yanked, cut, or deleted content (see :h quotequote)
nvim_set_keymap("n", "d", '""d', opts.nore)
nvim_set_keymap("n", "D", '""D', opts.nore)
nvim_set_keymap("n", "x", '""x', opts.nore)
nvim_set_keymap("n", "X", '""X', opts.nore)
nvim_set_keymap("n", "c", '""c', opts.nore)
nvim_set_keymap("n", "C", '""C', opts.nore)

-- ...navigate by soft-wrapped lines unless using number (e.g. 3j, 5k)
nvim_set_keymap("n", "j", "v:count == 0 ? 'gj' : 'j'", opts.noreExpr)
nvim_set_keymap("n", "k", "v:count == 0 ? 'gk' : 'k'", opts.noreExpr)

-- ...switch to windows on split
nvim_set_keymap("n", "<C-w>s", ":split | wincmd j<CR>", opts.noreSilent)
nvim_set_keymap("n", "<C-w>v", ":vsplit | wincmd l<CR>", opts.noreSilent)

-- ...resize in larger steps
nvim_set_keymap("n", "<C-w><", ":vertical resize -20<CR>", opts.noreSilent)
nvim_set_keymap("n", "<C-w>>", ":vertical resize +20<CR>", opts.noreSilent)

-- ...use the same next/previous direction for / and ?
-- nvim_set_keymap("", "n", "v:searchforward ? 'n' : 'N'", opts.noreExpr)
-- nvim_set_keymap("", "N", "v:searchforward ? 'N' : 'n'", opts.noreExpr)

--
-- Reload...
--

-- ...config
nvim_set_keymap("n", "<Leader>rr", "<Cmd>Reload<CR>", opts.nore)

-- ...config and trigger VimEnter
nvim_set_keymap("n", "<Leader>rR", "<Cmd>Restart<CR>", opts.nore)

-- ...file
nvim_set_keymap("n", "<Leader>rf", "<Cmd>source %<CR>", opts.nore)

-- ...plugins
nvim_set_keymap("n", "<Leader>rp", "<Cmd>PackerSync<CR>", opts.nore)

--
-- Navigate or move...
--

-- ...bufferline
nvim_set_keymap("n", "<M-h>", "<Cmd>lua require('cokeline/buffers').focus_by_step(-1)<CR>", opts.nore)
nvim_set_keymap("n", "<M-l>", "<Cmd>lua require('cokeline/buffers').focus_by_step(1)<CR>", opts.nore)
nvim_set_keymap("n", "<M-H>", "<Cmd>lua require('cokeline/buffers').switch_by_step(-1)<CR>", opts.nore)
nvim_set_keymap("n", "<M-L>", "<Cmd>lua require('cokeline/buffers').switch_by_step(1)<CR>", opts.nore)

--
-- Change...
--

-- ...sorting
nvim_set_keymap("v", "<Leader>cS", ":sort!<CR>", opts.nore)
nvim_set_keymap("v", "<Leader>cs", ":sort<CR>", opts.nore)

--
-- Lines
--

-- Insert new and toggle commenting (exit or begin comment block)
nvim_set_keymap("i", "<C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment()<CR>", opts.re)
nvim_set_keymap("i", "<S-C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment({ above = true })<CR>", opts.re)
nvim_set_keymap("n", "<C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment()<CR>", opts.re)
nvim_set_keymap("n", "<S-C-CR>", "<Cmd>lua NORDUtils.insert_line_and_toggle_comment({ above = true })<CR>", opts.re)

-- Insert line above and below current comment (more prominent)
nvim_set_keymap("i", "<M-CR>", "<Esc>O<Esc>jo<Esc>i", opts.re)
nvim_set_keymap("n", "<M-CR>", "O<Esc>jo<Esc>", opts.re)

-- Duplicate
nvim_set_keymap("i", "<S-CR>", "<Esc>yypA", opts.nore) -- Shift-Enter to duplicate in insert mode
nvim_set_keymap("n", "<S-CR>", "yyp$", opts.nore) -- Shift-Enter to duplicate in insert mode
nvim_set_keymap("n", "<Leader>ld", "yyp$", opts.nore) -- Leader-l-d => Line -> Duplicate
nvim_set_keymap("n", "<Leader>lD", "yyP$", opts.nore) -- Leader-l-D => Line -> Duplicate backwards

-- Move and reindent
nvim_set_keymap("n", "<S-C-k>", "<Cmd>m-2<CR>==", opts.nore)
nvim_set_keymap("n", "<S-C-j>", "<Cmd>m+<CR>==", opts.nore)
nvim_set_keymap("v", "<S-C-k>", ":m'<-2<CR>gv=gv", opts.nore)
nvim_set_keymap("v", "<S-C-j>", ":m'>+<CR>gv=gv", opts.nore)

--
-- Insert mode
--

-- Navigate
nvim_set_keymap("i", "<C-h>", "<Left>", opts.nore)
nvim_set_keymap("i", "<C-j>", "<Down>", opts.nore)
nvim_set_keymap("i", "<C-k>", "<Up>", opts.nore)
nvim_set_keymap("i", "<C-l>", "<Right>", opts.nore)

-- Delete
--
-- Note: Won't work in most terminal emulators since C-H usually emits ^H for historical reasons.
-- Here it's configured to be more useful.
nvim_set_keymap("i", "<S-BS>", "<Esc>dbxi", opts.nore) -- To beginning of word
nvim_set_keymap("i", "<C-BS>", "<Esc>d^xi", opts.nore) -- To beginning of line
nvim_set_keymap("i", "<S-C-BS>", "<Esc>ddkA", opts.nore) -- Whole line

--
-- Command mode
--

-- Navigate
nvim_set_keymap("c", "<C-a>", "<Home>", opts.re)
nvim_set_keymap("c", "<C-e>", "<End>", opts.re)
nvim_set_keymap("c", "<C-f>", "<Right>", opts.re)
nvim_set_keymap("c", "<C-b>", "<Left>", opts.re)
nvim_set_keymap("c", "<C-u>", "<End><C-u>", opts.nore) -- Kill whole line instead of left hand side
nvim_set_keymap("c", "<C-k>", "repeat('<Del>', strchars(getcmdline()[getcmdpos() - 1:]))", opts.expr) -- Kill from cursor

-- Modify
nvim_set_keymap("c", "<M-i>", "<Home><Right><Right><Right><Right>NORDUtils.inspect(<End>)<Left>", opts.nore) -- Inspect
nvim_set_keymap("c", "<M-l>", "<Home><Right><Right><Right><Right>NORDUtils.echo(<End>)<Left>", opts.nore) -- Echo
nvim_set_keymap("c", "<M-f>", "expand('%')", opts.expr) -- Insert path to current file
nvim_set_keymap("c", "<M-r>", "<C-u><C-r>:", opts.re) -- Insert last command

-- Prefill
nvim_set_keymap("n", "<Leader>;i", ":lua NORDUtils.inspect()<Left>", opts.re) -- Inspect
nvim_set_keymap("n", "<Leader>;u", ":lua NORDUtils.", opts.re) -- Utilities
nvim_set_keymap("n", "<Leader>;l", ":lua ", opts.re) -- Lua
nvim_set_keymap("n", "<Leader>;h", ":help ", opts.re) -- Help
nvim_set_keymap("n", "<Leader>;H", 'feedkeys(":help " . expand("<cword>"))', opts.expr) -- Help
nvim_set_keymap("n", "<Leader>;s", ":w <M-f>", opts.re) -- Write with filepath
nvim_set_keymap("n", "<Leader>;S", ":w !sudo tee > /dev/null %", opts.re) -- Sudo write
nvim_set_keymap("n", "<Leader>;r", ":<C-r>:", opts.re) -- Last command

--
-- Toggle...
--

-- ...quick action: word under cursor
nvim_set_keymap("", "<Leader>tt", "<Cmd>lua NORDUtils.toggle_word()<CR>", opts.nore)
nvim_set_keymap("", "<CR>", "<Cmd>lua NORDUtils.toggle_word()<CR>", opts.nore)
nvim_set_keymap("", "<C-t>", "<Cmd>lua NORDUtils.toggle_word()<CR>", opts.nore)
nvim_set_keymap("!", "<C-t>", "<Cmd>lua NORDUtils.toggle_word()<CR>", opts.nore)

-- ...side(b)ar
nvim_set_keymap("n", "<Leader>tb", "<Cmd>NvimTreeToggle<CR>", opts.nore)
nvim_set_keymap("n", "<C-b>", "<Cmd>lua require('nvim-tree').toggle()<CR>", opts.nore) -- (B)ar
nvim_set_keymap("n", "<C-b>b", "<Cmd>lua require('nvim-tree').toggle()<CR>", opts.nore) -- (B)ar
nvim_set_keymap("n", "<C-b><C-b>", "<Cmd>lua require('nvim-tree').toggle()<CR>", opts.nore) -- (B)ar

-- ...list characters
nvim_set_keymap("", "<Leader>tl", "<Cmd>set list!<CR>", opts.nore)

-- ...indent guides
nvim_set_keymap("", "<Leader>ti", "<Cmd>IndentBlanklineToggle<CR>", opts.nore)

-- ...file manager
nvim_set_keymap("n", "<Leader>tf", "<Cmd>Vifm<CR>", opts.nore)

-- ...Git information
nvim_set_keymap("n", "<Leader>tgg", "<Space>tgs<Space>tgb<Space>tgn<Space>tgr", opts.re)
nvim_set_keymap("n", "<Leader>tgs", "<Cmd>lua require('gitsigns.actions').toggle_signs()<CR>", opts.re)
nvim_set_keymap("n", "<Leader>tgn", "<Cmd>lua require('gitsigns.actions').toggle_numhl()<CR>", opts.re)
nvim_set_keymap("n", "<Leader>tgb", "<Cmd>lua require('gitsigns.actions').toggle_current_line_blame()<CR>", opts.re)
nvim_set_keymap("n", "<Leader>tgp", "<Cmd>lua require('gitsigns').preview_hunk()<CR>", opts.re)
nvim_set_keymap("n", "<Leader>tgB", "<Cmd>lua require('gitsigns').blame_line({full = true})<CR>", opts.re)
nvim_set_keymap("n", "]c", "&diff ? ']c' : '<Cmd>lua require(\"gitsigns.actions\").next_hunk()<CR>'", opts.expr)
nvim_set_keymap("n", "[c", "&diff ? ']c' : '<Cmd>lua require(\"gitsigns.actions\").prev_hunk()<CR>'", opts.expr)

-- ...highlights
nvim_set_keymap("n", "<Leader>th", "<Cmd>set hlsearch!<CR>", opts.nore)

-- Spelling
nvim_set_keymap("n", "<Leader>ts", "<Cmd>set spell!<CR>", opts.nore)

--
-- Find...
--

-- ...by shift tap: anything (shows menu)
nvim_set_keymap("n", "<Leader>F", "<Cmd>FzfLua<CR>", opts.nore)

-- ...by double tap: files
nvim_set_keymap("n", "<Leader>ff", "<Cmd>FzfLua files<CR>", opts.nore)

-- ...anything (shows menu)
nvim_set_keymap("n", "<Leader>fa", "<Cmd>FzfLua<CR>", opts.nore)

-- ...file by (g)rep
nvim_set_keymap("n", "<Leader>fg", "<Cmd>FzfLua live_grep_native<CR>", opts.nore)

-- ...buffer
nvim_set_keymap("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", opts.nore)

-- ...command
nvim_set_keymap("n", "<Leader>fc", "<Cmd>FzfLua commands<CR>", opts.nore)

-- ...colorscheme with live preview
nvim_set_keymap("n", "<Leader>fC", "<Cmd>FzfLua colorschemes<CR>", opts.nore)

-- ...help
nvim_set_keymap("n", "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", opts.nore)

-- ...mark
nvim_set_keymap("n", "<Leader>fm", "<Cmd>FzfLua marks<CR>", opts.nore)

-- ...key maps
nvim_set_keymap("n", "<Leader>fk", "<Cmd>FzfLua keymaps<CR>", opts.nore)

-- ...symbol (file)
nvim_set_keymap("n", "<Leader>fs", "<Cmd>FzfLua lsp_document_symbols<CR>", opts.nore)

-- ...symbol (workspace)
nvim_set_keymap("n", "<Leader>fS", "<Cmd>FzfLua lsp_workspace_symbols<CR>", opts.nore)

-- ...file by (r)esuming last query
nvim_set_keymap("n", "<Leader>fr", "<Cmd>FzfLua files_resume<CR>", opts.nore)

--
-- Buffer...
--

-- Quick command: list buffers
nvim_set_keymap("n", "<Space>bb", "<Cmd>FzfLua buffers<CR>", opts.nore)

-- ...list (same as <Leader>fb)
nvim_set_keymap("n", "<Space>bl", "<Cmd>FzfLua buffers<CR>", opts.nore)

-- ...list (old-school using ls)
nvim_set_keymap("n", "<Space>bL", "<Cmd>ls<CR>:b<Space>", opts.nore)

-- ...delete (wipeout, not just hide)
nvim_set_keymap("n", "<Space>bd", "<Cmd>bwipeout<CR>", opts.nore)

--
-- Put/paste...
--

-- ...time as YYYY-MM-DD HH:MM
nvim_set_keymap("n", "<Leader>pt", '"=strftime("%Y-%m-%d %H:%M")<CR>p', opts.nore)
abbreviate("time", "strftime('%Y-%m-%d %H:%M')", { expr = true })

-- ...time as MMM DD, YYYY
nvim_set_keymap("n", "<Leader>pT", '"=strftime("%b %d, %Y")<CR>p', opts.nore)
abbreviate("date", "strftime('%b %d, %Y')", { expr = true })

--
-- Editor
--

-- Search and replace
nvim_set_keymap("i", "<C-f>", "<Esc>:%s/<C-r><C-w>//g<Left><Left>", opts.nore)
nvim_set_keymap("n", "<C-f>", ":%s/<C-r><C-w>//g<Left><Left>", opts.nore)
nvim_set_keymap("v", "<C-f>", '"ay:%s/<C-r>a//g<Left><Left>', opts.nore)

--
-- Language diagnostic...
--

-- ...quick action: toggle diagnostics window
nvim_set_keymap("n", "<Leader>dd", "<Cmd>TroubleToggle<CR>", opts.nore)

-- ...formatting
nvim_set_keymap("n", "<Leader>df", "<Cmd>lua vim.lsp.buf.formatting()<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>dF", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>", opts.silent)

-- ...refactoring
nvim_set_keymap("n", "<F2>", '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.nore)
nvim_set_keymap("i", "<F2>", '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>dr", '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>dR", ":TSLspRenameFile<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>do", ":TSLspOrganize<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>di", ":TSLspImportAll<CR>", opts.nore)

-- ...navigation
nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts.nore)
nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("i", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dn", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dN", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts.nore)

-- ...display
nvim_set_keymap("n", "<Leader>dl", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts.nore)

--
-- Go to/do with word or line...
--

-- ..help
nvim_set_keymap("n", "gh", '<Cmd>call execute("help " . expand("<cword>"))<CR>', opts.re) -- Help

-- ..search web
nvim_set_keymap("n", "gs", "<Cmd>NBrowserSearch<CR>", opts.re)

--
-- Go to/do with text object...
--

-- ...search web
nvim_set_keymap("n", "<Leader>gs", "<Cmd>lua NORDUtils.browsersearch()<CR>", opts.re)
