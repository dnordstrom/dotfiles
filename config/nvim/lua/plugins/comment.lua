----
-- COMMENT.NVIM
----

--
-- SETUP
--
-- Note: pre_hook uses nvim-ts-context-commentstring for correct commenting of TSX/JSX markup
--

require("Comment").setup({
	pre_hook = function(ctx)
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