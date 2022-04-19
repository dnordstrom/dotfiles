----
-- LUASNIP
--
-- References:
--
--     - https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua
----
-- Load
-- Extend
--     -

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
-- Extend filetypes
--

ls.filetype_extend("sh", { "shell" })
local conds = require("luasnip.extras.expand_conditions")
local from_lua = require("luasnip.loaders.from_lua")
local from_vscode = require("luasnip.loaders.from_vscode")

--
-- Setup
--

ls.config.setup({})
ls.filetype_extend("javascriptreact", { "javascript" })
ls.filetype_extend("typescript", { "javascript" })
ls.filetype_extend("typescriptreact", { "typescript", "javascriptreact" })

--
-- Load snippets
--

from_vscode.load()
from_lua.load()
