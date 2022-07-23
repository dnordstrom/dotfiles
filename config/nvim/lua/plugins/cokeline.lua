----
-- COKELINE.NVIM
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

-- Symbols
local icon_modified = ""
local modified = ""
local unmodified = ""
local corner_left = ""
local corner_right = ""

-- Colors
local modified_blend = "#E38C8F"
local focused_fg = "#1E1E28"
local focused_bg = "#EBDDAA"
local unfocused_fg = darken(get_hex("TabLineSel", "fg"), 0.9)
local unfocused_bg = get_hex("TabLineSel", "bg")
local separator_fg = get_hex("LineNr", "fg")

-- Styles
local focused_style = "bold"
local focused_pre_style = "italic"
local focused_post_style = "bold"
local unfocused_style = "none"
local unfocused_pre_style = "italic"
local unfocused_post_style = "none"

--
-- COLORS
--

-- Tab text
local tab_fg = function(buffer)
	local fg

	if buffer.is_focused then
		if buffer.is_modified then
			fg = darken(focused_fg, 0.8)
		else
			fg = focused_fg
		end
	else
		if buffer.is_modified then
			fg = lighten(focused_fg, 0.95)
		else
			fg = unfocused_fg
		end
	end

	return fg
end

-- Tab background
local tab_bg = function(buffer)
	local bg

	if buffer.is_focused then
		if buffer.is_modified then
			bg = blend(focused_bg, modified_blend, 0)
		else
			bg = focused_bg
		end
	else
		if buffer.is_modified then
			bg = blend(unfocused_bg, modified_blend, 0.4)
		else
			bg = unfocused_bg
		end
	end

	return bg
end

-- Icon
local tab_icon = function(buffer)
	if buffer.is_focused then
		if buffer.is_modified then
			return lighten(tab_fg(buffer), 1)
		else
			return lighten(tab_fg(buffer), 0.9)
		end
	else
		if buffer.is_modified then
			return darken(tab_fg(buffer), 0.9)
		else
			return darken(tab_fg(buffer), 0.7)
		end
	end
end

-- Unique prefix
local tab_prefix = function(buffer)
	if buffer.is_focused then
		return lighten(tab_fg(buffer), 0.9)
	else
		return darken(tab_fg(buffer), 0.9)
	end
end

-- Corner symbol
local corner_fg = function(buffer)
	return tab_bg(buffer)
end

-- Corner background
local corner_bg = function(buffer)
	return "NONE"
end

-- Modification icon
local tab_suffix = function(buffer)
	if buffer.is_focused then
		if buffer.is_modified then
			return lighten(tab_fg(buffer), 0.7)
		else
			return lighten(tab_fg(buffer), 0.9)
		end
	else
		if buffer.is_modified then
			return darken(tab_fg(buffer), 0.9)
		else
			return darken(tab_fg(buffer), 0.7)
		end
	end
end

--
-- STYLES
--

-- Filename
local tab_style = function(buffer)
	return buffer.is_focused and focused_style or unfocused_style
end

-- Unique prefix
local tab_prefix_style = function(buffer)
	return buffer.is_focused and focused_pre_style or unfocused_pre_style
end

--
-- COMPONENTS
--

local components =
	{
		-- Padding
		padding = {
			text = " ",
			hl = { fg = "NONE", bg = "NONE" },
		},

		-- Left corners
		corner_left = {
			text = corner_left,
			hl = { fg = corner_fg, bg = corner_bg },
		},

		-- Filetype icon
		filetype_icon_or_modified_indicator = {
			text = function(buffer)
				if buffer.is_modified then
					return " " .. icon_modified .. " "
				else
					return " " .. buffer.devicon.icon
				end
			end,
			hl = { fg = tab_icon, bg = tab_bg },
		},

		-- Directory prefix if needed
		dirname_as_unique_prefix = {
			text = function(buffer)
				return buffer.unique_prefix
			end,
			hl = {
				bg = tab_bg,
				fg = tab_prefix,
				style = tab_prefix_style,
			},
		},

		-- Filename
		filename = {
			text = function(buffer)
				return buffer.filename .. " "
			end,
			hl = { style = tab_style, fg = tab_fg, bg = tab_bg },
		},

		-- Modified indicator
		modified_indicator = {
			text = function(buffer)
				local output = ""

				if buffer.is_modified then
					if modified ~= "" then
						output = modified .. " "
					end
				else
					if unmodified ~= "" then
						output = unmodified .. " "
					end
				end

				return output
			end,
			hl = { fg = tab_suffix, bg = tab_bg },
		},

		-- Right corners
		corner_right = {
			text = corner_right,
			hl = { fg = corner_fg, bg = corner_bg },
		},
	},
	
	--
	-- SETUP
	--

	-- Tabline background
vim.cmd("hi TabLineFill guibg=none gui=none")

-- Tabline settings
require("cokeline").setup({
	show_if_buffers_are_at_least = 2,

	buffers = {
		new_buffers_position = "next",
	},
	mappings = {
		cycle_prev_next = true,
	},
	default_hl = {
		fg = tab_fg,
		bg = tab_bg,
	},
	components = {
		components.corner_left,
		components.padding,
		components.filetype_icon_or_modified_indicator,
		components.filename,
		components.modified_indicator,
		components.padding,
		components.corner_right,
	},
})
