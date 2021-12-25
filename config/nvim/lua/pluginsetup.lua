----
-- PLUGIN CONFIGURATION
----

local utils = require("utils")
local get_hex = utils.get_hex
local lighten = utils.color.lighten
local darken = utils.color.darken
local blend = utils.color.blend

-- INDENT-BLANKLINE.NVIM

require("indent_blankline").setup({
	char = " ", -- Empty space overrides listchar if both are enabled
	context_char = "▕",
	space_char_blankline = " ",
	show_end_of_line = false,
	show_current_context = true,
	show_current_context_start = false,
})

--
-- COKELINE.NVIM
--
--   - Separators: https://github.com/famiu/feline.nvim/blob/master/USAGE.md#default-separators
--   - Icons: https://github.com/just3ws/nerd-font-cheatsheets
--

--
-- Variables
--

-- Colors

local modified_blend = "#E38C8F"

local focused_fg = "#1E1E28"
local focused_bg = "#EBDDAA"

local unfocused_fg = darken(get_hex("TabLineSel", "fg"), 0.9)
local unfocused_bg = get_hex("TabLineSel", "bg")

local separator_fg = get_hex("LineNr", "fg")

-- Styles

local focused_style = "bold"
local focused_pre_style = "italic"
local focused_post_style = "bold"

local unfocused_style = "none"
local unfocused_pre_style = "italic"
local unfocused_post_style = "none"

-- Symbols

--[[
- Nerd Fonts:    https://www.nerdfonts.com/cheat-sheet
- Powerline:     https://github.com/ryanoasis/powerline-extra-symbols
- Separator:      ·  
- Modified:       
- Unmodified:    
- Left corner:       
- Right corner:       
--]]

local separator = " "
local icon_modified = ""
local modified = ""
local unmodified = ""
local corner_left = ""
local corner_right = ""

--
-- Colors
--

-- Tab text
local tab_fg = function(buffer)
	local fg

	if buffer.is_focused then
		if buffer.is_modified then
			fg = darken(focused_fg, 0.8)
		else
			fg = focused_fg
		end
	else
		if buffer.is_modified then
			fg = lighten(focused_fg, 0.95)
		else
			fg = unfocused_fg
		end
	end

	return fg
end

-- Tab background
local tab_bg = function(buffer)
	local bg

	if buffer.is_focused then
		if buffer.is_modified then
			bg = blend(focused_bg, modified_blend, 0)
		else
			bg = focused_bg
		end
	else
		if buffer.is_modified then
			bg = blend(unfocused_bg, modified_blend, 0.4)
		else
			bg = unfocused_bg
		end
	end

	return bg
end

-- Icon
local tab_icon = function(buffer)
	if buffer.is_focused then
		if buffer.is_modified then
			return lighten(tab_fg(buffer), 1)
		else
			return lighten(tab_fg(buffer), 0.9)
		end
	else
		if buffer.is_modified then
			return darken(tab_fg(buffer), 0.9)
		else
			return darken(tab_fg(buffer), 0.7)
		end
	end
end

-- Unique prefix
local tab_prefix = function(buffer)
	if buffer.is_focused then
		return lighten(tab_fg(buffer), 0.9)
	else
		return darken(tab_fg(buffer), 0.9)
	end
end

-- Corner symbols
local corner_fg = function(buffer)
	return tab_bg(buffer)
end

-- Corner background
local corner_bg = function(buffer)
	return "none"
end

-- Modification icon
local tab_suffix = function(buffer)
	if buffer.is_focused then
		if buffer.is_modified then
			return lighten(tab_fg(buffer), 0.7)
		else
			return lighten(tab_fg(buffer), 0.9)
		end
	else
		if buffer.is_modified then
			return darken(tab_fg(buffer), 0.9)
		else
			return darken(tab_fg(buffer), 0.7)
		end
	end
end

--
-- Styles
--

-- Filename
local tab_style = function(buffer)
	return buffer.is_focused and focused_style or unfocused_style
end

-- Unique prefix
local tab_prefix_style = function(buffer)
	return buffer.is_focused and focused_pre_style or unfocused_pre_style
end

--
-- Setup
--

-- Tabline background
vim.cmd("hi TabLineFill guibg=none gui=none")

-- Tabline settings
require("cokeline").setup({
	cycle_prev_next_mappings = true,
	buffers = {
		new_buffers_position = "last",
	},
	default_hl = {
		focused = {
			fg = focused_fg,
			bg = focused_bg,
		},
		unfocused = {
			fg = unfocused_fg,
			bg = unfocused_bg,
		},
	},
	components = {
		-- Separator
		{
			text = function(buffer)
				return buffer.index ~= 1 and separator
			end,
			hl = { fg = separator_fg, bg = "none" },
		},
		-- Corner
		{
			text = corner_left,
			hl = { fg = corner_fg, bg = corner_bg },
		},
		-- Icon
		{
			text = function(buffer)
				if buffer.is_modified then
					return " " .. icon_modified .. " "
				else
					return " " .. buffer.devicon.icon
				end
			end,
			hl = { fg = tab_icon, bg = tab_bg },
		},
		-- Directory
		{
			text = function(buffer)
				return buffer.unique_prefix
			end,
			hl = {
				bg = tab_bg,
				fg = tab_prefix,
				style = tab_prefix_style,
			},
		},
		-- Filename
		{
			text = function(buffer)
				return buffer.filename .. " "
			end,
			hl = { style = tab_style, fg = tab_fg, bg = tab_bg },
		},
		-- Modified indicator
		{
			text = function(buffer)
				if buffer.is_modified then
					return modified ~= "" and modified .. " "
				else
					return unmodified ~= "" and unmodified .. " "
				end
			end,
			hl = { fg = tab_suffix, bg = tab_bg },
		},
		-- Corner
		{
			text = corner_right,
			hl = { fg = corner_fg, bg = corner_bg },
		},
	},
})

--
-- FZF-LUA
--

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
			title = "Normal",
		},

		-- Preview pane
		preview = {
			default = "builtin",
			border = "noborder",
			wrap = "nowrap",
			hidden = "nohidden",
			vertical = "down:45%",
			horizontal = "right:50%",
			layout = "flex",
			flip_columns = 120, -- Column to flip layout to horizontal at
			scrollbar = false,
			winopts = {
				number = true,
				relativenumber = false,
				cursorline = false,
				cursorlineopt = "both",
				cursorcolumn = false,
				signcolumn = "no",
				list = false,
				foldenable = false,
				foldmethod = "manual",
			},
		},
	},

	-- Key maps
	keymap = {
		builtin = {
			-- Preview navigation on Alt
			["<M-f>"] = "toggle-fullscreen",
			["<M-w>"] = "toggle-preview-wrap",
			["<M-p>"] = "toggle-preview",
			["<M-h>"] = "preview-page-up",
			["<M-j>"] = "preview-page-down",
			["<M-k>"] = "preview-page-up",
			["<M-l>"] = "preview-page-down",
			["<M-u>"] = "preview-page-up",
			["<M-d>"] = "preview-page-down",
		},
		fzf = {
			-- Fzf navigation on Ctrl
			["ctrl-space"] = "toggle",
			["ctrl-z"] = "abort",
			["ctrl-a"] = "beginning-of-line",
			["ctrl-e"] = "end-of-line",
			["ctrl-u"] = "half-page-up",
			["ctrl-d"] = "half-page-down",

			-- Native preview navigation on Alt
			["alt-p"] = "toggle-preview",
			["alt-h"] = "preview-page-up",
			["alt-j"] = "preview-page-down",
			["alt-k"] = "preview-page-up",
			["alt-l"] = "preview-page-down",
		},
	},
	file_icon_padding = "",
	-- Command arguments
	fzf_bin = "fzf",
	fzf_opts = {
		["--ansi"] = "",
		["--no-info"] = "",
		["--prompt"] = "' Find › '",
		["--marker"] = "' »'",
		["--pointer"] = "' ➔'",
	},
	files = {
		prompt = " Files › ",
		fd_opts = "--color never --type f --hidden --exclude .git --exclude node_modules",
	},
	git = {
		files = {
			prompt = " Git › ",
			cmd = "git ls-files --exclude-standard",
		},
		status = {
			prompt = " Diff › ",
		},
		commits = {
			prompt = " Commits › ",
		},
		bcommits = {
			prompt = " Commits › ",
		},
		branches = {
			prompt = " Branches › ",
		},
	},
	grep = {
		prompt = " Grep › ",
		input_prompt = "Grep › ",
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
		grep_opts = "--binary-files=without-match --line-number --recursive --color=auto --perl-regexp",
		experimental = true, -- Enable icons for files and Git (decreases performance)

		-- live_grep glob options
		glob_flag = "--iglob", -- Use --glob for case sensitive
		glob_separator = "%s%-%-", -- Query separator pattern (lua): ' --'
	},
	builtin = {
		prompt = " Find › ",
	},
	args = {
		prompt = " Args › ",
	},
	oldfiles = {
		prompt = " Recent › ",
	},
	buffers = {
		prompt = " Buffers › ",
	},
	lines = {
		prompt = " Lines › ",
	},
	blines = {
		prompt = " Buffer lines › ",
	},
	keymaps = {
		prompt = " Key maps › ",
	},
	marks = {
		prompt = " Marks › ",
	},
	registers = {
		prompt = " Registers › ",
	},
	colorschemes = {
		prompt = " Colorschemes › ",
		winopts = {
			-- Use smaller window for colorscheme preview
			fullscreen = false,
			border = "single",
			col = 0.5,
			row = 0.2,
			height = 0.6,
			width = 0.3,
		},
		post_reset_cb = function()
			require("feline").reset_highlights()
		end,
	},
	quickfix = {
		prompt = " Quick fix › ",
		file_icons = true,
		git_icons = true,
	},
	lsp = {
		prompt = " › ",
		async_or_timeout = true,
		file_icons = true,
		git_icons = false,
		lsp_icons = true,
		severity = "hint",
		icons = {
			["Error"] = { icon = "", color = "red" },
			["Warning"] = { icon = "", color = "yellow" },
			["Information"] = { icon = "", color = "blue" },
			["Hint"] = { icon = "", color = "magenta" },
		},
	},
})

--
-- FELINE.NVIM
--

local vi_mode_utils = require("feline.providers.vi_mode")
local components = { active = {}, inactive = {} }
local status_fg = get_hex("Normal", "fg")
local status_bg = get_hex("CokeUnfocused", "bg")
local status_style = "bold"
local fill_separator = {
	str = " ",
	hl = {
		bg = status_bg,
	},
}

components.active[1] = {
	{
		provider = "file_type",
		hl = {
			style = "bold",
			bg = get_hex("CokeUnfocused", "bg"),
		},
		left_sep = fill_separator,
		right_sep = fill_separator,
	},
	{
		provider = "",
		hl = function()
			return {
				name = vi_mode_utils.get_mode_highlight_name(),
				bg = status_bg,
				fg = vi_mode_utils.get_mode_color(),
				style = status_style,
			}
		end,
	},
	{
		provider = "vi_mode",
		hl = function()
			return {
				name = vi_mode_utils.get_mode_highlight_name(),
				fg = "black",
				bg = get_hex("CokeFocused", "bg"),
				-- bg = vi_mode_utils.get_mode_color(),
				style = status_style,
			}
		end,
		left_sep = {
			str = " ",
			hl = function()
				return {
					name = vi_mode_utils.get_mode_highlight_name(),
					-- bg = vi_mode_utils.get_mode_color(),
					bg = get_hex("CokeFocused", "bg"),
				}
			end,
		},
		right_sep = {
			str = " ",
			hl = function()
				return {
					name = vi_mode_utils.get_mode_highlight_name(),
					-- bg = vi_mode_utils.get_mode_color(),
					bg = get_hex("CokeFocused", "bg"),
				}
			end,
		},
		icon = "",
	},
	{
		provider = "", -- "",
		hl = function()
			return {
				name = vi_mode_utils.get_mode_highlight_name(),
				bg = status_bg,
				fg = vi_mode_utils.get_mode_color(),
				style = status_style,
			}
		end,
		right_sep = fill_separator,
	},
	{
		provider = "file_info",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		left_sep = fill_separator,
		right_sep = fill_separator,
	},
}

components.active[2] = {
	{
		provider = "diagnostic_errors",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "diagnostic_warnings",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "diagnostic_info",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "diagnostic_hints",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_diff_added",
		icon = "烙",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_diff_changed",
		icon = " ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_diff_removed",
		icon = " ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_branch",
		hl = {
			fg = get_hex("CokeFocused", "fg"),
			bg = get_hex("CokeFocused", "bg"),
			style = status_style,
		},
		left_sep = {
			str = " ",
			hl = {
				bg = get_hex("CokeFocused", "bg"),
			},
		},
		right_sep = {
			str = " ",
			hl = {
				bg = get_hex("CokeFocused", "bg"),
			},
		},
	},
	{
		provider = "line_percentage",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		left_sep = fill_separator,
		right_sep = fill_separator,
	},
}

local status_inactive_bg = darken(status_bg, 0.65)
local status_inactive_fg = darken(status_fg, 0.65)

components.inactive[1] = {
	{
		provider = "file_type",
		hl = {
			bg = status_inactive_bg,
			fg = status_inactive_fg,
			style = status_style,
		},
		left_sep = {
			str = " ",
			hl = {
				bg = status_inactive_bg,
			},
		},
		right_sep = {
			str = " ",
			hl = {
				bg = status_inactive_bg,
			},
		},
	},
}

components.inactive[2] = {
	{
		provider = "file_info",
		hl = {
			fg = status_inactive_fg,
			bg = status_inactive_bg,
			style = status_style,
		},
	},
}

require("feline").setup({
	default_bg = "#cccccc",
	default_fg = get_hex("Normal", "fg"),
	components = components,
})

--
-- NVIM-TREE
--

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

--
-- SURROUND.NVIM
--

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

--
-- LUASNIP
--

require("luasnip.loaders.from_vscode").lazy_load()

--
-- COMMENT.NVIM
--

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

--
-- NVIM-TREESITTER
--

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

--
-- WHICH-KEY
--

require("which-key").setup({
	plugins = {
		marks = true,
		registers = true,
		spelling = {
			enabled = false,
			suggestions = 20,
		},
		presets = {
			operators = true,
			motions = true,
			text_objects = true,
			windows = true,
			nav = true,
			z = true,
			g = true,
		},
	},
	key_labels = {
		["<space>"] = "Space",
		["<cr>"] = "Enter",
		["<tab>"] = "Tab",
		["<esc>"] = "Escape",
		["<bs>"] = "Backspace",
	},
	icons = {
		breadcrumb = "+",
		separator = "  ",
		group = " ",
	},
	popup_mappings = {
		scroll_down = "<c-d>",
		scroll_up = "<c-u>",
	},
	window = {
		border = "single",
		position = "bottom",
		margin = { 4, 4, 2, 4 },
		padding = { 1, 1, 1, 1 },
	},
	layout = {
		height = { min = 4, max = 25 },
		width = { min = 20, max = 50 },
		spacing = 5,
		align = "left",
	},
	ignore_missing = false,
	hidden = { "<Silent>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " },
	show_help = false, -- Disabled since it outputs lowercase text
	triggers = "auto",
	triggers_blacklist = {
		i = { "j", "k" },
		v = { "j", "k" },
	},
})

--
-- TODO-COMMENTS
--

require("todo-comments").setup({})

--
-- TROUBLE
--

require("trouble").setup({
	mode = "document_diagnostics",
	use_diagnostic_signs = true,
})

--
-- NVIM-CMP, LSPKIND-NVIM, LUASNIP, NVIM-AUTOPAIRS
--

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
		native_menu = true,
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

-- NVIM-AUTOPAIRS

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

-- RENAMER

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

-- COLORIZER

require("colorizer").setup()

-- GITSIGNS

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
