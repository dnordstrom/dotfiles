----
-- INDENT-BLANKLINE.NVIM
----

require("indent_blankline").setup({
	char = " ",
	context_char = "·", -- Reference characters: ▕  
	space_char_blankline = " ",
	show_end_of_line = false,
	show_current_context = true,
	show_current_context_start = false,
})
