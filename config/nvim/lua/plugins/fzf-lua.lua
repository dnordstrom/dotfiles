----
-- FZF-LUA
----

local actions = require("fzf-lua.actions")
local prompt = "  "

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
			wrap = "wrap",
			hidden = "nohidden",
			vertical = "down:25%",
			horizontal = "right:35%",
			layout = "flex",
			flip_columns = 120, -- Column to flip layout to horizontal at
			scrollbar = true,
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
			["<M-p>"] = "toggle-preview",
			["<M-return>"] = "toggle-preview",
			["<M-w>"] = "toggle-preview-wrap",
			["<M-z>"] = "toggle-preview-wrap",

			["<M-h>"] = "preview-page-up",
			["<M-j>"] = "preview-down",
			["<M-k>"] = "preview-up",
			["<M-l>"] = "preview-page-down",

			["<M-u>"] = "preview-page-up",
			["<M-d>"] = "preview-page-down",
		},
		fzf = {
			-- Fzf navigation on Ctrl
			["ctrl-z"] = "abort",
			["ctrl-space"] = "toggle-down",
			["alt-space"] = "toggle-up",

			["ctrl-p"] = "up",
			["ctrl-n"] = "down",

			["ctrl-u"] = "page-up",
			["ctrl-d"] = "page-down",

			["ctrl-h"] = "backward-char",
			["ctrl-j"] = "down",
			["ctrl-k"] = "up",
			["ctrl-l"] = "forward-char",

			-- Preview navigation on Alt
			["alt-p"] = "toggle-preview",
			["alt-return"] = "toggle-preview",
			["alt-w"] = "toggle-preview-wrap",
			["alt-z"] = "toggle-preview-wrap",

			["alt-h"] = "preview-page-up",
			["alt-j"] = "preview-down",
			["alt-k"] = "preview-up",
			["alt-l"] = "preview-page-down",
		},
	},
	-- Command arguments
	fzf_bin = "fzf",
	fzf_opts = {
		["--ansi"] = "",
		["--cycle"] = "",
		["--info"] = "hidden",
		["--prompt"] = "'" .. prompt .. "'",
		["--marker"] = "' »'",
		["--pointer"] = "' ➔'",
		["--ellipsis"] = "'…'",
	},
	files = {
		prompt = prompt,
		fd_opts = "--type file --hidden --exclude .git --exclude node_modules",
	},
	git = {
		files = {
			prompt = prompt,
			cmd = "git ls-files --exclude-standard",
		},
		status = {
			prompt = prompt,
		},
		commits = {
			prompt = prompt,
		},
		bcommits = {
			prompt = prompt,
		},
		branches = {
			prompt = prompt,
		},
	},
	grep = {
		prompt = prompt,
		input_prompt = prompt,
		rg_opts = "--column --line-number --no-heading --color=always --smart-case --max-columns=512",
		grep_opts = "--binary-files=without-match --line-number --recursive --color=always --perl-regexp",
		experimental = true, -- Enable icons for files and Git (decreases performance)

		-- live_grep glob options
		glob_flag = "--iglob", -- Use --glob for case sensitive
		glob_separator = "%s%-%-", -- Query separator pattern (lua): ' --'
	},
	builtin = {
		prompt = prompt,
	},
	args = {
		prompt = prompt,
	},
	oldfiles = {
		prompt = prompt,
	},
	buffers = {
		prompt = prompt,
	},
	lines = {
		prompt = prompt,
	},
	blines = {
		prompt = prompt,
	},
	keymaps = {
		prompt = prompt,
	},
	marks = {
		prompt = prompt,
	},
	registers = {
		prompt = prompt,
	},
	colorschemes = {
		prompt = prompt,
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
		prompt = prompt,
		file_icons = true,
		git_icons = true,
	},
	places = {
		prompt = prompt,
	},
	lsp = {
		prompt = prompt,
		async_or_timeout = true,
		file_icons = true,
		git_icons = true,
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
