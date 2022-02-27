----
-- INDENT-BLANKLINE.NVIM
--
-- PragmataPro character reference: https://fsd.it/pragmatapro/All_chars.txt
----

local get_hex = require("utils").get_hex

require("indent_blankline").setup({
	char = " ",
	context_char = "▕", 
	space_char_blankline = " ",
	show_end_of_line = false,
	show_current_context = true,
	show_current_context_start = false,
})

-- Fetch context character color from Comment highlight group

vim.cmd("hi IndentBlanklineContextChar guifg=" .. get_hex("Comment", "fg") .. " gui=nocombine")
