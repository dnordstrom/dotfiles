----
-- LUASNIP
--
-- References:
--
--     - https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
----

local ls = require("luasnip")
local fmt = require("luasnip.extras.fmt").fmt
local filetype_functions = require("luasnip.extras.filetype_functions")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.expand_conditions")
local from_vscode = require("luasnip.loaders.from_vscode")

--
-- Extend filetypes
--

ls.filetype_extend("sh", { "shell" })
ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "typescript", "javascriptreact" })

--
-- Custom snippets
--

ls.snippets.all = {
	s({
		trig = "date",
		name = "date",
		dscr = "Current date",
	}, p(os.date, "%Y-%m-%d")),
	s({
		trig = "datetime",
		name = "datetime",
		dscr = "Current date and time",
	}, p(os.date, "%Y-%m-%d %H:%M")),
	s({
		trig = "time",
		name = "time",
		dscr = "Current time",
	}, p(os.date, "%H:%M")),
}

--
-- Setup
--

ls.config.setup({
	-- updateevents = "TextChanged,TextChangedI",
	-- Use nvim-treesitter to determine filetype based on cursor position to get the right snippets
	-- in embedded contexts like CSS in JS. Unfortunately doesn't work as it should.
	-- ft_func = filetype_functions.from_pos_or_filetype,
})

--
-- Load snippets (must come after our own snippets unless we extend `ls.snippets` tables)
--

from_vscode.lazy_load()
