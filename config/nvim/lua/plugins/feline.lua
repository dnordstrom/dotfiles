----
-- FELINE.NVIM
--
-- Status line plugin written in Lua.
--
-- References:
--
--    - Separators:         https://github.com/famiu/feline.nvim/blob/master/USAGE.md#default-separators
--    - Nerd Fonts:         https://www.nerdfonts.com/cheat-sheet
--    - Nerd Fonts sheets:  https://github.com/just3ws/nerd-font-cheatsheets
--    - Powerline:          https://github.com/ryanoasis/powerline-extra-symbols
--    - Separator:           ·  
--    - Modified:            
--    - Unmodified:         
--    - Left corner:            
--    - Right corner:            
----

--
-- VARIABLES 
--

-- Utils
local utils = require("utils")
local get_hex = utils.get_hex
local lighten = utils.color.lighten
local darken = utils.color.darken
local blend = utils.color.blend

-- Colors
local status_fg = darken(get_hex("Normal", "fg"), 0.8)
local status_bg = get_hex("CokeUnfocused", "bg")
local status_style = "bold"
local status_em_fg = lighten(get_hex("CokeFocused", "fg"), 0.95)
local status_em_bg = get_hex("CokeFocused", "bg")
local status_inactive_bg = darken(status_bg, 0.65)
local status_inactive_fg = darken(status_fg, 0.65)

--
-- SETUP
--

local vi_mode_utils = require("feline.providers.vi_mode")
local components = { active = {}, inactive = {} }
local fill_separator = {
	str = " ",
	hl = {
		bg = status_bg,
	},
}

--
-- Active left
--

components.active[1] = {
	{
		provider = "file_type",
		hl = {
			style = "bold",
			fg = get_hex("Special", "fg"),
			bg = status_bg,
		},
		left_sep = fill_separator,
		right_sep = fill_separator,
	},
	{
		provider = "",
		hl = function()
			return {
				name = vi_mode_utils.get_mode_highlight_name(),
				bg = status_bg,
				fg = vi_mode_utils.get_mode_color(),
				style = status_style,
			}
		end,
	},
	{
		provider = "vi_mode",
		hl = function()
			return {
				name = vi_mode_utils.get_mode_highlight_name(),
				fg = status_em_fg,
				bg = status_em_bg,
				style = status_style,
			}
		end,
		left_sep = {
			str = "  ",
			hl = function()
				return {
					name = vi_mode_utils.get_mode_highlight_name(),
					fg = vi_mode_utils.get_mode_color(),
					bg = status_em_bg,
				}
			end,
		},
		right_sep = {
			str = " ",
			hl = {
				bg = status_em_bg,
			},
		},
		icon = "",
	},
	{
		provider = {
			name = "file_info",
			opts = {
				type = "unique", -- Shows directory for buffers with identical filenames
				file_modified_icon = "",
				file_readonly_icon = "聯",
			},
		},
		hl = {
			bg = status_bg,
			style = status_style,
		},
		left_sep = fill_separator,
		right_sep = fill_separator,
	},
	{
		provider = "position",
		hl = {
			fg = darken(status_fg, 0.75),
			bg = status_bg,
			style = status_style,
		},
		left_sep = {
			str = " ",
			hl = {
				fg = get_hex("Special", "fg"),
				bg = status_bg,
				style = status_style,
			},
		},
		right_sep = fill_separator,
	},
}

--
-- Active right
--

components.active[2] = {
	{
		provider = "diagnostic_errors",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "diagnostic_warnings",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "diagnostic_info",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "diagnostic_hints",
		icon = "  ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_diff_added",
		icon = "烙",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_diff_changed",
		icon = " ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_diff_removed",
		icon = " ",
		hl = {
			bg = status_bg,
			style = status_style,
		},
		right_sep = fill_separator,
	},
	{
		provider = "git_branch",
		hl = {
			fg = status_em_fg,
			bg = status_em_bg,
			style = status_style,
		},
		left_sep = {
			str = " ",
			hl = {
				bg = status_em_bg,
			},
		},
		right_sep = {
			str = " ",
			hl = {
				bg = status_em_bg,
			},
		},
	},
	{
		provider = "line_percentage",
		hl = {
			fg = get_hex("Special", "fg"),
			bg = status_bg,
			style = status_style,
		},
		left_sep = fill_separator,
		right_sep = fill_separator,
	},
}

--
-- Inactive left
--

components.inactive[1] = {
	{
		provider = {
			name = "file_info",
			opts = {
				file_modified_icon = "",
				file_readonly_icon = "輦",
			},
		},
		hl = {
			fg = status_inactive_fg,
			bg = status_inactive_bg,
			style = status_style,
		},
		left_sep = {
			str = " ",
			hl = {
				bg = status_inactive_bg,
			},
		},
		right_sep = {
			str = " ",
			hl = {
				bg = status_inactive_bg,
			},
		},
	},
}

require("feline").setup({
	components = components,
})

