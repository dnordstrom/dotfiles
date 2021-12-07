----
-- PLUGIN CONFIGURATION
----

-- cokeline.nvim
--   - Separators: https://github.com/famiu/feline.nvim/blob/master/USAGE.md#default-separators

local get_hex = require("cokeline.utils").get_hex

vim.cmd("hi TabLineFill guibg=none gui=none")

local focused_tab_fg = "#222222" -- get_hex("Comment", "fg")
local focused_tab_bg = get_hex("LineNr", "fg")
local focused_tab_icon = "#333333" -- File icon
local focused_tab_pre = "#333333" -- Unique prefix
local focused_tab_post = "#333333" -- Modified icon
local focused_tab_style = "bold,italic" -- Text style
local focused_tab_pre_style = "none" -- Prefix text style
local unfocused_tab_fg = "#333333" -- get_hex("Search", "fg")
local unfocused_tab_bg = get_hex("Visual", "bg")
local unfocused_tab_icon = "#444444" -- File icon
local unfocused_tab_pre = "#444444" -- Unique prefix
local unfocused_tab_post = "#333333" -- Modified icon
local unfocused_tab_style = "none" -- Text style
local unfocused_tab_pre_style = "italic" -- Prefix text style

local separator = "#696969"
local corner_fg = function(buffer) return buffer.is_focused and focused_tab_bg or unfocused_tab_bg end
local corner_bg = function(buffer) return "none" end
local tab_fg = function(buffer) return buffer.is_focused and focused_tab_fg or unfocused_tab_fg end
local tab_bg = function(buffer) return buffer.is_focused and focused_tab_bg or unfocused_tab_bg end
local tab_pre = function(buffer) return buffer.is_focused and focused_tab_pre or unfocused_tab_pre end
local tab_post = function(buffer) return buffer.is_focused and focused_tab_post or unfocused_tab_post end
local tab_icon = function(buffer) return buffer.is_focused and focused_tab_icon or unfocused_tab_icon end -- Or buffer.devicon.color
local tab_style = function(buffer) return buffer.is_focused and focused_tab_style or unfocused_tab_style end
local tab_pre_style = function(buffer) return buffer.is_focused and focused_tab_pre_style or unfocused_tab_pre_style end

require("cokeline").setup({
	cycle_prev_next_mappings = true,
	buffers = {
		new_buffers_position = "last",
	},
	default_hl = {
    focused = {
      fg = focused_tab_fg,
      bg = focused_tab_bg,
    },
    unfocused = {
      fg = unfocused_tab_fg,
      bg = unfocused_tab_bg,
    },
  },
	components = {
    {
      text = function(buffer)
        return ""
      end,
      hl = {
        fg = corner_fg,
        bg = corner_bg,
      },
    },
		{
			text = function(buffer)
				return " " .. buffer.devicon.icon
			end,
			hl = {
        fg = tab_icon,
        bg = tab_bg,
			},
		},
		{
			text = function(buffer)
				return buffer.unique_prefix
			end,
			hl = {
				style = tab_pre_style,
				fg = tab_pre,
        bg = tab_bg,
			},
		},
		{
			text = function(buffer)
				return buffer.filename .. " "
			end,
      hl = {
        style = tab_style,
        fg = tab_fg,
        bg = tab_bg,
      },
		},
		{
			text = function(buffer) --  ﰉ
				return buffer.is_modified and " ⊛ "
			end,
				fg = tab_post,
        bg = tab_bg,
		},
    {
      text = function(buffer)
        return ""
      end,
      hl = {
        fg = corner_fg,
        bg = corner_bg,
      },
    },
    {
      text = function(buffer)
        local listedbufs = vim.tbl_filter(function(buf)
          return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, 'buflisted')
        end, vim.api.nvim_list_bufs())
        local lastbufnr = listedbufs[#listedbufs]

        if buffer.number == lastbufnr then
          return ""
        else
          return "  " -- "  "
          -- return " · "
        end
      end,
      hl = {
        fg = separator,
        bg = "none",
      },
    },
	},
})

local actions = require("fzf-lua.actions")

require("fzf-lua").setup({
	winopts = {
		-- Fullscreen floating window
		fullscreen = true,

		-- Size if disabling fullscreen
		split = false,
		height = 0.8,
		width = 0.8,
		row = 0.1,
		col = 0.1,
		border = "single",
		hl = {
			normal = "Normal",
			border = "FloatBorder",
			title = "FloatBorder",
		},
		preview = {
			default = "builtin",
			border = "noborder",
			wrap = "nowrap",
			hidden = "nohidden",
			vertical = "down:45%",
			horizontal = "right:60%",
			layout = "flex",
			flip_columns = 120, -- Column to flip layout to horizontal at
			scrollbar = false,
  
      -- Builtin previewer window
      winopts = {
        number = true,
        relativenumber = false,
        cursorline = true,
        cursorlineopt = "both",
        cursorcolumn = false,
        signcolumn = "no",
        list = false,
        foldenable = false,
        foldmethod = "manual",
      },
		},
		on_create = function()
			vim.api.nvim_buf_set_keymap(0, "t", "<C-h>", "<Left>", { silent = true, noremap = true })
			vim.api.nvim_buf_set_keymap(0, "t", "<C-j>", "<Down>", { silent = true, noremap = true })
			vim.api.nvim_buf_set_keymap(0, "t", "<C-k>", "<Up>", { silent = true, noremap = true })
			vim.api.nvim_buf_set_keymap(0, "t", "<C-l>", "<Right>", { silent = true, noremap = true })
		end,
	},
	keymap = {
		builtin = {
			["<M-f>"] = "toggle-fullscreen",
      ["<M-w>"] = "toggle-preview-wrap",
      ["<M-p>"] = "toggle-preview",
      ["<M-j>"] = "preview-page-down",
      ["<M-k>"] = "preview-page-up",
		},
		fzf = {
			["ctrl-space"] = "toggle",
			["ctrl-z"] = "abort",
			["ctrl-u"] = "unix-line-discard",
			["ctrl-f"] = "half-page-down",
			["ctrl-b"] = "half-page-up",
			["ctrl-a"] = "beginning-of-line",
			["ctrl-e"] = "end-of-line",
			["ctrl-p"] = "up",
			["ctrl-n"] = "down",

      -- If using native previewers
			["alt-p"] = "toggle-preview",
			["alt-j"] = "preview-page-down",
			["alt-k"] = "preview-page-up",
		},
	},
	fzf_bin = "fzf",
	fzf_opts = {
		["--ansi"] = "",
		["--prompt"] = "❯ ",
		["--info"] = "inline",
		["--height"] = "100%",
		["--layout"] = "reverse",
	},
	-- fzf --color options
	fzf_colors = {
		["fg"] = { "fg", "CursorLine" },
		["bg"] = { "bg", "Normal" },
		["hl"] = { "fg", "Comment" },
		["fg+"] = { "fg", "Normal" },
		["bg+"] = { "bg", "CursorLine" },
		["hl+"] = { "fg", "Statement" },
		["info"] = { "fg", "PreProc" },
		["prompt"] = { "fg", "Conditional" },
		["pointer"] = { "fg", "Exception" },
		["marker"] = { "fg", "Keyword" },
		["spinner"] = { "fg", "Label" },
		["header"] = { "fg", "Comment" },
		["gutter"] = { "bg", "Normal" },
	},
	files = {
		prompt = "Files ❯ ",
		fd_opts = "--color never --type f --hidden --exclude .git --exclude node_modules",
	},
	git = {
		files = {
			prompt = "Git files ❯ ",
			cmd = "git ls-files --exclude-standard",
		},
		status = {
			prompt = "Git status ❯ ",
		},
		commits = {
			prompt = "Commits ❯ ",
		},
		bcommits = {
			prompt = "Buffer commits ❯ ",
		},
		branches = {
			prompt = "Branches ❯ ",
		},
	},
	grep = {
		prompt = "Grep ❯ ",
		input_prompt = "Grep for ❯ ",
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
		grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
		experimental = true, -- Enable icons for files and Git (decreases performance)

		-- live_grep_glob options
		glob_flag = "--iglob", -- Use --glob for case sensitive
		glob_separator = "%s%-%-", -- Query separator pattern (lua): ' --'
	},
	builtin = {
		prompt = "Builtin ❯ ",
  },
	args = {
		prompt = "Args ❯ ",
	},
	oldfiles = {
		prompt = "History ❯ ",
	},
	buffers = {
		prompt = "Buffers ❯ ",
	},
	lines = {
		prompt = "Lines ❯ ",
	},
	blines = {
		prompt = "Buffer lines ❯ ",
	},
	keymaps = {
		prompt = "Key maps ❯ ",
	},
	marks = {
		prompt = "Marks ❯ ",
	},
	registers = {
		prompt = "Registers ❯ ",
	},
	colorschemes = {
		prompt = "Colorschemes ❯ ",
		winopts = {
      fullscreen = false,
      border = "single",
      col = 0.5,
      row = 0.2,
			height = 0.6,
			width = 0.3,
		},
		post_reset_cb = function()
			require('feline').reset_highlights()
		end,
	},
	quickfix = {
		file_icons = true,
		git_icons = true,
	},
	lsp = {
		prompt = "LSP ❯ ",
		async_or_timeout = true,
		file_icons = true,
		git_icons = false,
		lsp_icons = true,
		severity = "hint",
		icons = {
			["Error"] = { icon = "", color = "red" },
			["Warning"] = { icon = "", color = "yellow" },
			["Information"] = { icon = "", color = "blue" },
			["Hint"] = { icon = "", color = "magenta" },
		},
	},
})

-- nvim-tree

local tree = require("nvim-tree")

-- Custom relative resize function where positive number increases and negative number decreases,
-- e.g. require('nvim-tree').custom_resize(-5) decreases width by 5 columns. Due to a bug, it also
-- toggles the tree twice to apply the new size.
--
--   - See: https://github.com/kyazdani42/nvim-tree.lua/issues/672#issuecomment-931938002
tree.custom_resize = function(size)
	local tree = require("nvim-tree")
	local width = require("nvim-tree.view").View.width

	tree.resize(width + size)
	tree.toggle()
	tree.toggle()
end

tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {},
	auto_close = false,
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = false,
	update_to_buf_dir = {
		enable = true,
		auto_open = true,
	},
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = false,
		update_cwd = false,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 30,
		height = 30,
		hide_root_folder = false,
		side = "left",
		auto_resize = true,
		mappings = {
			custom_only = false,
			list = {
				{
					key = "<M-h>",
					cb = "<Cmd>lua require('nvim-tree').custom_resize(-5)<CR>",
				},
				{
					key = "<M-l>",
					cb = "<Cmd>lua require('nvim-tree').custom_resize(5)<CR>",
				},
			},
		},
		number = false,
		relativenumber = false,
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
})

-- surround.nvim

require("surround").setup({
	mappings_style = "sandwich",
	map_insert_mode = false, -- pears.nvim handles this
	quotes = { "'", '"', "`" },
	brackets = { "(", "{", "[", "<" },
	pairs = {
		nestable = {
			{ "(", ")" },
			{ "[", "]" },
			{ "{", "}" },
			{ "<", ">" },
		},
		linear = {
			{ "'", "'" },
			{ '"', '"' },
			{ "`", "`" },
		},
	},
	prefix = "<C-s>",
})

-- LuaSnip

require("luasnip.loaders.from_vscode").lazy_load()

-- Comment.nvim

require("Comment").setup({
	pre_hook = function(ctx)
		-- Use nvim-ts-context-commentstring for commenting TSX/JSX markup
		if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
			local U = require("Comment.utils")
			local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"
			local location = nil

			if ctx.ctype == U.ctype.block then
				location = require("ts_context_commentstring.utils").get_cursor_location()
			elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
				location = require("ts_context_commentstring.utils").get_visual_start_location()
			end

			return require("ts_context_commentstring.internal").calculate_commentstring({
				key = type,
				location = location,
			})
		end
	end,
})

-- nvim-treesitter

require("nvim-treesitter.configs").setup({
	ensure_installed = "all",
	context_commentstring = {
		enable = true,
	},
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			keymaps = {
				["al"] = "@loop.outer",
				["il"] = "@loop.inner",
				["ab"] = "@block.outer",
				["ib"] = "@block.inner",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
				["af"] = "@function.outer",
				["if"] = "@function.inner",
				["ap"] = "@parameter.outer",
				["ip"] = "@parameter.inner",
				["ak"] = "@comment.outer",
				["ac"] = "@class.outer",
				["ic"] = "@class.inner",
			},
		},
		swap = {
			enable = true,
			swap_next = {
				["<leader>a"] = "@parameter.inner",
			},
			swap_previous = {
				["<leader>A"] = "@parameter.inner",
			},
		},
		move = {
			enable = true,
			set_jumps = true,
			goto_next_start = {
				["]m"] = "@function.outer",
				["]]"] = "@class.outer",
			},
			goto_next_end = {
				["]M"] = "@function.outer",
				["]["] = "@class.outer",
			},
			goto_previous_start = {
				["[m"] = "@function.outer",
				["[["] = "@class.outer",
			},
			goto_previous_end = {
				["[M"] = "@function.outer",
				["[]"] = "@class.outer",
			},
		},
	},
})

-- Show maps when typing

require("which-key").setup({
	plugins = {
		marks = true, -- shows a list of your marks on ' and `
		registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
		spelling = {
			enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
			suggestions = 20, -- how many suggestions should be shown in the list?
		},
		-- The presets plugin, adds help for a bunch of default keybindings in Neovim
		-- No actual key bindings are created
		presets = {
			operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
			motions = true, -- adds help for motions
			text_objects = true, -- help for text objects triggered after entering an operator
			windows = true, -- default bindings on <c-w>
			nav = true, -- misc bindings to work with windows
			z = true, -- bindings for folds, spelling and others prefixed with z
			g = true, -- bindings for prefixed with g
		},
	},
	-- Add operators that will trigger motion and text object completion
	-- to enable all native operators, set the preset/operators plugin above
	operators = {
		gc = "Comments",
		gs = "Web search",
	},
	key_labels = {
		-- Override the label used to display some keys. It doesn't effect WK in any other way.
		-- For example:
		["<space>"] = "Space",
		["<cr>"] = "Enter",
		["<tab>"] = "Tab",
		["<esc>"] = "Escape",
		["<bs>"] = "Backspace",
	},
	icons = {
		breadcrumb = "»", -- Symbol used in the command line area that shows your active key combo
		separator = "➜", -- Symbol used between a key and it's label
		group = "+", -- Symbol prepended to a group
	},
	popup_mappings = {
		scroll_down = "<C-d>", -- Binding to scroll down inside the popup
		scroll_up = "<C-u>", -- Binding to scroll up inside the popup
	},
	window = {
		border = "double", -- None, single, double, shadow
		position = "bottom", -- Bottom, top
		margin = { 4, 4, 2, 4 }, -- Extra window margin [top, right, bottom, left]
		padding = { 1, 1, 1, 1 }, -- Extra window padding [top, right, bottom, left]
		winblend = 10, -- Value between 1 and 100
	},
	layout = {
		height = { min = 4, max = 25 }, -- Min and max height of the columns
		width = { min = 20, max = 50 }, -- Min and max width of the columns
		spacing = 3, -- Spacing between columns
		align = "left", -- Align columns left, center or right
	},
	ignore_missing = false, -- Enable this to hide mappings for which you didn't specify a label
	hidden = { "<Silent>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- Hide mapping boilerplate
	show_help = true, -- show help message on the command line when the popup is visible
	triggers = "auto", -- automatically setup triggers
	triggers_blacklist = {
		i = { "j", "k" },
		v = { "j", "k" },
	},
})

-- Comment labels

require("todo-comments").setup({})

-- Trouble

require("trouble").setup({
	mode = "lsp_document_diagnostics",
	use_lsp_diagnostic_signs = true,
})

-- feline

require("feline").setup({ preset = "noicon" })

-- nvim-cmp, lspkind-nvim, luasnip, nvim-autopairs

-- Checks if cursor directly follows text
local has_word_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp = require("cmp")
local mapping = cmp.mapping

-- Smart Tab navigates completion menu if visible, toggles completion if cursor follows text, and
-- otherwise falls back to normal tab insertion behavior
local function smart_tab(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_jumpable() then
		luasnip.expand_or_jump()
	elseif has_word_before() then
		cmp.complete()
	else
		fallback()
	end
end

-- Smart Shift-Tab navigates completion menu if visible, otherwise falls back to normal behavior
local function smart_shift_tab(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

-- Defaults at https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
cmp.setup({
	snippet = {
		-- Use luasnip for snippets
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		-- Completion close behavior depending on mode
		["<C-e>"] = mapping({
			i = mapping.abort(), -- Close and restore line in insert mode
			c = mapping.close(), -- Close and discard line in command mode
		}),

		-- Only input mode is mapped unless otherwise specified, so these do not conflict with default
		-- command mode mappings
		["<C-u>"] = mapping.scroll_docs(-4),
		["<C-d>"] = mapping.scroll_docs(4),
		["<C-n>"] = mapping.select_next_item(),
		["<C-p>"] = mapping.select_prev_item(),

		-- Pressing enter without selection automatically inserts the top item in insert mode
		["<CR>"] = mapping.confirm({ select = true }),

		-- Use Tab for selection and Ctrl-Space for completion toggle in all modes
		["<Tab>"] = mapping(smart_tab, { "i", "s" }),
		["<S-Tab>"] = mapping(smart_shift_tab, { "i", "s" }),
		["<C-Space>"] = mapping(mapping.complete(), { "i", "s" }),
	},
	sources = {
		-- Input mode sources
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "rg" },
		{ name = "calc" },
		{ name = "spell" },
		{ name = "look" },
		{ name = "emoji" },
	},
	formatting = {
		-- Use lspkind-nvim to display source as icon instead of text
		format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
	},

	-- Experimental features default to false
	experimental = {
		ghost_text = true,
	},
})

-- Search completion
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
		{ name = "treesitter" },
		{ name = "nvim_lsp" },
		{ name = "rg" },
	},
})

-- Command completion
cmp.setup.cmdline(":", {
	sources = {
		{ name = "path" },
		{ name = "cmdline" },
		{ name = "calc" },
		{ name = "rg" },
	},
})

-- nvim-autopairs

local npairs = require("nvim-autopairs")

npairs.setup({
	check_ts = true,
	ts_config = {
		lua = { "string" }, -- it will not add a pair on that treesitter node
		javascript = { "template_string" },
		java = false, -- don't check treesitter on java
	},
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))

-- Renamer

local mappings_utils = require("renamer.mappings.utils")

require("renamer").setup({
	title = "Rename",
	padding = {
		top = 0,
		left = 0,
		bottom = 0,
		right = 0,
	},
	border = true,
	border_chars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
	show_refs = true,
	with_qf_list = true,
	with_popup = true,
	mappings = {
		["<c-i>"] = mappings_utils.set_cursor_to_start,
		["<c-a>"] = mappings_utils.set_cursor_to_end,
		["<c-e>"] = mappings_utils.set_cursor_to_word_end,
		["<c-b>"] = mappings_utils.set_cursor_to_word_start,
		["<c-c>"] = mappings_utils.clear_line,
		["<c-u>"] = mappings_utils.undo,
		["<c-r>"] = mappings_utils.redo,
	},
	handler = nil,
})

-- Colorizer

require("colorizer").setup()

-- Gitsigns

require("gitsigns").setup({
	signs = {
		add = { hl = "GitSignsAdd", text = "│", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
		change = { hl = "GitSignsChange", text = "│", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
		delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		topdelete = { hl = "GitSignsDelete", text = "‾", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
		changedelete = { hl = "GitSignsChange", text = "~", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
	},
	signcolumn = false,
	numhl = false,
	linehl = false,
	word_diff = false,
	keymaps = {
		noremap = true,
	},
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = false,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "right_align",
		delay = 500,
		ignore_whitespace = true,
	},
	current_line_blame_formatter_opts = {
		relative_time = false,
	},
	sign_priority = 6,
	update_debounce = 500,
	status_formatter = nil,
	max_file_length = 40000,
	preview_config = {
		border = "double",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 2,
	},
	yadm = {
		enable = false,
	},
})
