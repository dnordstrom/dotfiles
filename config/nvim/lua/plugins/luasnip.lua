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
-- Setup
--

ls.config.set_config({
	history = true,
	-- Update more often, :h events for more info.
	update_events = "TextChanged,TextChangedI",
	-- Snippets aren't automatically removed if their text is deleted.
	-- `delete_check_events` determines on which events (:h events) a check for
	-- deleted snippets is performed.
	-- This can be especially useful when `history` is enabled.
	delete_check_events = "TextChanged",
	ext_opts = {
		[types.choiceNode] = {
			active = {
				virt_text = { { "choiceNode", "Comment" } },
			},
		},
	},
	-- treesitter-hl has 100, use something higher (default is 200).
	ext_base_prio = 300,
	-- minimal increase in priority.
	ext_prio_increase = 1,
	enable_autosnippets = true,
	-- mapping for cutting selected text so it's usable as SELECT_DEDENT,
	-- SELECT_RAW or TM_SELECTED_TEXT (mapped via xmap).
	store_selection_keys = "<Tab>",
	-- luasnip uses this function to get the currently active filetype. This
	-- is the (rather uninteresting) default, but it's possible to use
	-- eg. treesitter for getting the current filetype by setting ft_func to
	-- require("luasnip.extras.filetype_functions").from_cursor (requires
	-- `nvim-treesitter/nvim-treesitter`). This allows correctly resolving
	-- the current filetype in eg. a markdown-code block or `vim.cmd()`.
	ft_func = function()
		return vim.split(vim.bo.filetype, ".", true)
	end,
})

--
-- Custom snippets
--

ls.add_snippets("all", {
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
})

--
-- Load snippets (must come after our own snippets unless we extend `ls.snippets` tables)
--

from_vscode.lazy_load()
