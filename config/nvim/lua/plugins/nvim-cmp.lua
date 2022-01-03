----
-- NVIM-CMP
----

-- Checks if cursor directly follows text
local has_word_before = function()
	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp = require("cmp")
local mapping = cmp.mapping

-- Tab function that...
--
--   - ...triggers completion if cursor directly follows text
--   - ...navigates completion if menu is visible
--   - ...navigates position if inserting snippet
--   - ...falls back to provided function otherwise
--
local function smart_tab(fallback)
	if cmp.visible() then
		cmp.select_next_item()
	elseif luasnip.expand_or_locally_jumpable() then -- "locally" to only jump if inside snippet
		luasnip.expand_or_jump()
	elseif has_word_before() then
		cmp.complete()
	else
		fallback()
	end
end

-- Shift-Tab function that...
--
--   - ...navigates completion if menu is visible
--   - ...navigates position if inserting snippet
--   - ...falls back to provided function otherwise
--
local function smart_shift_tab(fallback)
	if cmp.visible() then
		cmp.select_prev_item()
	elseif luasnip.expand_or_locally_jumpable(-1) then
		luasnip.jump(-1)
	else
		fallback()
	end
end

-- Defaults at https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
cmp.setup({
	snippet = {
		-- Use luasnip for snippets
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = {
		--
		-- Note: Insert mode is used if mode is omitted
		--

		-- Navigation
		["<C-u>"] = function()
			utils.feedkeys("<PageUp>")
		end,
		["<C-d>"] = function()
			utils.feedkeys("<PageDown>")
		end,

		-- Close behavior depending on mode
		["<C-e>"] = mapping({
			i = mapping.abort(), -- Close and restore line in insert mode
			c = mapping.close(), -- Close and discard line in command mode
		}),

		-- Enter behavior (`select = true` will select first item automatically)
		["<CR>"] = mapping.confirm({ select = false }),

		-- Tab behavior
		["<Tab>"] = mapping(smart_tab, { "i", "s" }),
		["<S-Tab>"] = mapping(smart_shift_tab, { "i", "s" }),

		-- Completion triggers
		["<C-Tab>"] = mapping(mapping.complete(), { "i", "s" }),
		["<C-Space>"] = mapping(mapping.complete(), { "i", "s" }),
	},
	sources = {
		-- Input mode sources
		{ name = "nvim_lsp" },
		{ name = "treesitter" },
		{ name = "buffer" },
		{ name = "luasnip" },
		{ name = "path" },
		{ name = "rg" },
		{ name = "calc" },
		{ name = "spell" },
		{ name = "look" },
		{ name = "emoji" },
	},
	formatting = {
		-- Use lspkind-nvim to display icon instead of text
		format = lspkind.cmp_format({ with_text = false, maxwidth = 50 }),
	},

	-- Experimental features default to false
	experimental = {
		native_menu = true,
		ghost_text = true,
	},
})

-- Search completion
cmp.setup.cmdline("/", {
	sources = {
		{ name = "buffer" },
		{ name = "treesitter" },
		{ name = "nvim_lsp" },
		{ name = "rg" },
	},
})

-- Command completion
cmp.setup.cmdline(":", {
	sources = {
		{ name = "path" },
		{ name = "cmdline" },
		{ name = "calc" },
		{ name = "rg" },
	},
})

-- Autopair on confirm
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({ map_char = { tex = "" } }))
