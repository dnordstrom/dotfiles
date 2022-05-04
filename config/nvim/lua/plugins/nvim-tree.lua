----
-- NVIM-TREE
----

local tree = require("nvim-tree")

--
-- Custom relative resize function where positive number increases and negative number decreases,
-- e.g. require('nvim-tree').custom_resize(-5) decreases width by 5 columns. Due to a bug, it also
-- toggles the tree twice to apply the new size.
--
--   - Bug: https://github.com/kyazdani42/nvim-tree.lua/issues/672#issuecomment-931938002
--
tree.custom_resize = function(size)
	local tree = require("nvim-tree")
	local width = require("nvim-tree.view").View.width

	tree.resize(width + size)
	tree.toggle()
	tree.toggle()
end

tree.setup({
	disable_netrw = true,
	hijack_netrw = true,
	open_on_setup = false,
	ignore_ft_on_setup = {},
	open_on_tab = false,
	hijack_cursor = false,
	update_cwd = false,
	diagnostics = {
		enable = false,
		icons = {
			hint = "",
			info = "",
			warning = "",
			error = "",
		},
	},
	update_focused_file = {
		enable = false,
		update_cwd = false,
		ignore_list = {},
	},
	system_open = {
		cmd = nil,
		args = {},
	},
	filters = {
		dotfiles = false,
		custom = {},
	},
	git = {
		enable = true,
		ignore = true,
		timeout = 500,
	},
	view = {
		width = 30,
		height = 30,
		hide_root_folder = false,
		side = "left",
		mappings = {
			custom_only = false,
			list = {
				{
					key = "<M-h>",
					cb = "<Cmd>lua require('nvim-tree').custom_resize(-5)<CR>",
				},
				{
					key = "<M-l>",
					cb = "<Cmd>lua require('nvim-tree').custom_resize(5)<CR>",
				},
			},
		},
		number = false,
		relativenumber = false,
	},
	trash = {
		cmd = "trash",
		require_confirm = true,
	},
})
