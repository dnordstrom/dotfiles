----
-- WHICH-KEY
----

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
