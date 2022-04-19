--
-- ALL FILETYPES
--

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

--
-- Snippets
--

local snippets = {
	s("time", p(os.date, "%H:%M")),
	s("date", p(os.date, "%Y-%m-%d")),
	s("datetime", p(os.date, "%Y-%m-%d %H:%M")),
}

ls.add_snippets("all", snippets, { key = "all" })

return snippets
