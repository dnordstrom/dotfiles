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
local keymap = vim.keymap
local opts = {
	-- "Regular"
	re = { noremap = false },
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

-- ...highlight toggle
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
nvim_set_keymap("n", "ZA", "<Cmd>w!<CR>", opts.nore)

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
nvim_set_keymap("n", "<M-h>", "<Plug>(cokeline-focus-prev)", opts.re)
nvim_set_keymap("n", "<M-l>", "<Plug>(cokeline-focus-next)", opts.re)
nvim_set_keymap("n", "<M-H>", "<Plug>(cokeline-switch-prev)", opts.re)
nvim_set_keymap("n", "<M-L>", "<Plug>(cokeline-switch-next)", opts.re)

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
nvim_set_keymap("c", "<C-u>", "<End><C-u>", opts.nore) -- Kill line
nvim_set_keymap("c", "<C-h>", "<Left>", opts.re)
nvim_set_keymap("c", "<C-j>", "<C-u>", opts.re) -- Kill to beginning
nvim_set_keymap("c", "<C-k>", "repeat('<Del>', strchars(getcmdline()[getcmdpos() - 1:]))", opts.expr) -- Kill to end
nvim_set_keymap("c", "<C-l>", "<Right>", opts.re)

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
nvim_set_keymap("n", "<Leader>;s", ":w <M-f>", opts.re) -- Write with file path
nvim_set_keymap("n", "<Leader>;S", ":cp --no-preserve=mode,ownership % $(mktmp)", opts.re) -- Sudo write
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

-- ...color column
nvim_set_keymap("", "<Leader>tc", '<Cmd>execute "set colorcolumn=" . (&colorcolumn == "" ? "+1" : "")<CR>', opts.nore)

-- ...file manager
nvim_set_keymap("n", "<Leader>tf", "<Cmd>Vifm<CR>", opts.nore)

-- ...command bar height
nvim_set_keymap("n", "<Leader>tc", "<Cmd>set cmdheight=0<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>tC", "<Cmd>set cmdheight=2<CR>", opts.nore)

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

-- ...spellchecking
nvim_set_keymap("n", "<Leader>ts", "<Cmd>set spell!<CR>", opts.nore)

--
-- Find...
--

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

-- ...color scheme with live preview
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

-- ...recent files
nvim_set_keymap("n", "<Leader>fr", "<Cmd>FzfLua oldfiles<CR>", opts.nore)

-- ..."undo" last query (resume)
nvim_set_keymap("n", "<Leader>fu", "<Cmd>FzfLua resume<CR>", opts.nore)

--
-- Buffer...
--

-- Quick command: list buffers
nvim_set_keymap("n", "<Space>bb", "<Cmd>FzfLua buffers<CR>", opts.nore)

-- ...list (same as <Leader>fb)
nvim_set_keymap("n", "<Space>bl", "<Cmd>FzfLua buffers<CR>", opts.nore)

-- ...list (old-school using ls)
nvim_set_keymap("n", "<Space>bL", "<Cmd>ls<CR>:b<Space>", opts.nore)

-- ...delete (default is hide)
nvim_set_keymap("n", "<Space>bd", "<Cmd>Bwipeout<CR>", opts.nore)

-- ...delete despite changes (default is hide)
nvim_set_keymap("n", "<Space>bD", "<Cmd>Bwipeout!<CR>", opts.nore)

-- ...delete file (recoverable in Vifm trash directory)
nvim_set_keymap(
	"n",
	"<Leader>bD",
	":!mv --backup=numbered %:p ~/.local/share/vifm/Trash/%<CR>:Bwipeout<CR>",
	opts.silent
)

-- ...temporary file (e.g. when readonly, copies path to clipboard and opens in new buffer)
nvim_set_keymap(
	"n",
	"<Leader>bt",
	':!file=$(mktemp); cp --no-preserve=mode,ownership %:p $file; wl-copy "$file"<CR>:e <C-r>+<CR>',
	opts.silent
)

-- ...temporary file (e.g. when readonly, copies path to clipboard and opens in new terminal window)
nvim_set_keymap(
	"n",
	"<Leader>bT",
	":!file=$(mktemp); cp --no-preserve=mode,ownership %:p $file; nohup kitty --title popupterm -e nvim $file &<CR>",
	opts.silent
)

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
nvim_set_keymap("i", "<C-f>", "<Esc>:set cmdheight=2<CR>:%s/<C-r><C-w>//g<Left><Left>", opts.nore)
nvim_set_keymap("n", "<C-f>", "<Esc>:set cmdheight=2<CR>:%s/<C-r><C-w>//g<Left><Left>", opts.nore)
nvim_set_keymap("v", "<C-f>", '"ty:set cmdheight=2<CR>:%s/<C-r>t//g<Left><Left>', opts.nore)
nvim_set_keymap("i", "<C-S-f>", "<Esc>:set cmdheight=2<CR>:%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>", opts.nore)
nvim_set_keymap("n", "<C-S-f>", "<Esc>:set cmdheight=2<CR>:%s/<C-r><C-w>/<C-r><C-w>/g<Left><Left>", opts.nore)
nvim_set_keymap("v", "<C-S-f>", '"ty:set cmdheight=2<CR>:%s/<C-r>t/<C-r>t/g<Left><Left>', opts.nore)

--
-- Language diagnostic...
--

-- ...quick action: toggle diagnostics window
nvim_set_keymap("n", "<Leader>dd", "<Cmd>TroubleToggle<CR>", opts.nore)

-- ...formatting
nvim_set_keymap("n", "<Leader>df", "<Cmd>lua vim.lsp.buf.format()<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>dF", "<Cmd>lua vim.lsp.buf.range_format()<CR>", opts.silent)

-- ...refactoring
nvim_set_keymap("n", "<Leader>dr", ":lua require('refactoring').select_refactor()<CR>", opts.nore)
nvim_set_keymap("i", "<M-Leader>dr", ":lua require('refactoring').select_refactor()<CR>", opts.nore)
nvim_set_keymap("i", "<C-r>", ":lua require('refactoring').select_refactor()<CR>", opts.nore)
nvim_set_keymap("n", "<F2>", '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.nore)
nvim_set_keymap("i", "<F2>", '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>dc", '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.nore)

-- ...navigation
nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts.nore)
nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("i", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dn", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dN", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts.nore)

-- ...display
nvim_set_keymap("n", "<Leader>dl", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts.nore)

-- ...generate documentation comment (e.g. JSDoc)
keymap.set("n", "<Leader>dg", require("neogen").generate, { desc = "Generate documentation comment" })

--
-- Go to/do with word or line...
--

-- ...help
nvim_set_keymap("n", "gh", '<Cmd>call execute("help " . expand("<cword>"))<CR>', opts.re) -- Help

-- ...search web
nvim_set_keymap("n", "gs", "<Cmd>NBrowserSearch<CR>", opts.re)

--
-- Go to/do with text object...
--

-- ...search web
nvim_set_keymap("n", "<Leader>gs", "<Cmd>lua NORDUtils.browsersearch()<CR>", opts.re)

--
-- New...
--
-- By default uses active file directory, and capital letter variants use working directory.
--

-- ..file
nvim_set_keymap("n", "<Leader>nf", 'feedkeys(":e " . expand("%:~:h") . "/")', opts.expr)
nvim_set_keymap("n", "<Leader>nF", 'feedkeys(":e " . getcwd() . "/")', opts.expr)

-- ..directory
nvim_set_keymap("n", "<Leader>nd", 'feedkeys(":!mkdir -p " . expand("%:~:h") . "/")', opts.expr)
nvim_set_keymap("n", "<Leader>nD", 'feedkeys(":!mkdir -p " . getcwd() . "/")', opts.expr)

-- ..buffer (unnamed, no input required)
nvim_set_keymap("n", "<Leader>nb", '<Cmd>execute("e " . expand("%:~:h") . "/Unnamed")<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>nB", '<Cmd>execute("e " . getcwd() . "/Unnamed")<CR>', opts.nore)

-- To use the built-in prompt, if you prefer less flexibility for no added value:
-- nvim_set_keymap("n", "<Leader>nF", '<Cmd>execute("e " . getcwd() . "/" . input("New file (relative): "))<CR>', opts.nore)
