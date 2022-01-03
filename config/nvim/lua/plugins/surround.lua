----
-- SURROUND.NVIM
----

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
