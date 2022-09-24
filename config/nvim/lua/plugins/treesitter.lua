----
-- NVIM-TREESITTER
----

require("nvim-treesitter.configs").setup({
	-- Install missing parsers automatically.
	auto_install = true,

	-- Install initial parsers from https://github.com/nvim-treesitter/nvim-treesitter#supported-languages.
	ensure_installed = {
		"bash",
		"comment",
		"css",
		"dockerfile",
		"go",
		"gomod",
		"graphql",
		"help",
		"html",
		"java",
		"javascript",
		"jsdoc",
		"json",
		"jsonc",
		"lua",
		"make",
		"markdown",
		"markdown_inline",
		"nix",
		"php",
		"python",
		"rasi",
		"regex",
		"ruby",
		"scss",
		"sql",
		"swift",
		"todotxt",
		"toml",
		"tsx",
		"typescript",
		"vim",
		"yaml",
	},

	-- Module for context aware commenting, e.g. `{/* JS/TS comments in JSX/TSX}`.
	context_commentstring = {
		enable = true,
	},

	-- Module for additional text objects.
	textobjects = {
		select = {
			enable = true,
			lookahead = true,
			lookbehind = true,
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

		-- Scope navigation maps.
		incremental_selection = {
			enable = true,
			keymaps = {
				init_selection = "gnn",
				node_decremental = "grm",
				node_incremental = "grn",
				scope_incremental = "grc",
			},
		},

		-- Parameter swap maps.
		swap = {
			enable = true,
			swap_next = { ["<Leader>ct"] = "@parameter.inner" },
			swap_previous = { ["<Leader>cT"] = "@parameter.inner" },
		},

		-- Navigation maps.
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
