----
-- UTILITIES
----

local color = require("lib.color")
local api = vim.api
local fn = vim.fn
local go = vim.go
local operatorfunc = vim.go.operatorfunc
local nvim_feedkeys = vim.api.nvim_feedkeys
local nvim_echo = vim.api.nvim_echo
local nvim_exec = vim.api.nvim_exec
local nvim_get_mode = vim.api.nvim_get_mode
local nvim_buf_get_mark = vim.api.nvim_buf_get_mark
local nvim_buf_get_lines = vim.api.nvim_buf_get_lines
local nvim_replace_termcodes = vim.api.nvim_replace_termcodes

-- Replaces Vim termcodes in string.
local t = function(str)
	return nvim_replace_termcodes(str, true, true, true)
end

-- Replaces Vim termcodes in string, and feeds it as key presses.
local feedkeys = function(str)
	nvim_feedkeys(t(str), "m", true)
end

--- Merges two tables, the second taking precedence when both contain the same key.
---
--- @param a First table
--- @param b Second table
--- @returns Resulting table
local merge_tables = function(first, second)
	local result = {}

	for k, v in pairs(first) do
		result[k] = v
	end

	for k, v in pairs(second) do
		result[k] = v
	end

	return result
end

-- Gets Neovim version in `vX.X.X-dev` format.
local get_version = function()
	return nvim_exec(
		[[
    echo matchstr(execute("version"), "NVIM \\zs[^\\n]*")
  ]],
		true
	)
end

-- Get date/time
local date = function(format)
	return os.date(format or "%Y-%m-%d %H:%M")
end

-- Inspect variables/tables
local inspect = function(var)
	print(vim.inspect(var))
end

-- Show a simple message
local echo = function(message, highlight, label_highlight)
	local message = message or "Empty message."
	local highlight = highlight or "Comment"
	local label_highlight = label_highlight or "healthSuccess"

	nvim_echo({
		{ "\r\rNORDUtils", label_highlight },
		{ ": ", highlight },
		{ message, highlight },
	}, true, {})
end

-- Get word under cursor with simple expansion
local cword = function()
	return vim.fn.expand("<cword>")
end

-- Copy object
_G.copy = function(obj, seen)
	if type(obj) ~= "table" then
		return obj
	end

	if seen and seen[obj] then
		return seen[obj]
	end

	local s = seen or {}
	local res = {}

	s[obj] = res

	for k, v in next, obj do
		res[copy(k, s)] = copy(v, s)
	end

	return setmetatable(res, getmetatable(obj))
end

local copy = _G.copy

-- Opens Google search for provided query using xdg-open. If no query is provided, sets operatorfunc
-- and goes into operator pending mode waiting for text object. If query is an empty string (e.g.
-- if called via Vim command without passing an argument), the word under the cursor is used.
local browsersearch = function(query)
	if query == nil then
		-- Called from bind, goes into operator pending mode
		operatorfunc = "v:lua.NORDUtils.browsersearch"
		feedkeys("g@")

		return -- Wait for query
	else
		-- Either called with text object or empty string
		local command = "xdg-open" -- os.getenv("BROWSER") or "firefox" may work on Windows, who knows
		local url = "https://google.com/search?q="

		if query == "" then
			-- Empty string, use cword expansion instead of text object to prevent cursor movement
			query = fn.expand("<cword>")
		else
			-- Operator provided query, get text as single line string
			local start = nvim_buf_get_mark(0, "[")
			local finish = nvim_buf_get_mark(0, "]")
			local lines = nvim_buf_get_lines(0, start[1] - 1, finish[1], false)
			local to_hex = function(char)
				return string.format("%%%02X", string.byte(char))
			end

			-- Join lines if multiple are selected
			if #lines > 1 then
				query = table.concat(lines, " ")
			else
				query = lines[1]:sub(start[2] + 1, finish[2] + 1)
			end

			-- Escape URL
			query = query:gsub("([^%w ])", to_hex)
			query = query:gsub("%s+", "+")
		end

		-- Launch process
		io.popen(command .. ' "' .. url .. query .. '"')
	end
end

-- Insert a new line and toggle commenting with gcc (uses a temporarily inserted character
-- as workaround for plugins that don't allow comment toggling on blank lines
local insert_line_and_toggle_comment = function(opts)
	local opts = opts or { above = false }
	local mode = nvim_get_mode().mode
	local typekeys = function(str)
		-- Replace termcodes in string and feed result as typed keys
		nvim_feedkeys(t(str), "m", true)
	end

	if mode == "n" and opts.above then
		typekeys("^On<Esc>gcc$xa")
	elseif mode == "n" and not opts.above then
		typekeys("^on<Esc>gcc$xa")
	elseif mode == "i" and opts.above then
		typekeys("<Esc>^On<Esc>gcc$xa")
	elseif mode == "i" and not opts.above then
		typekeys("<Esc>^on<Esc>gcc$xa")
	end
end

-- Replace the return statement for this file, generating a new object that includes all local
-- variables/functions which directly follow a comment. Using x<Esc>r{ to not trigger autopairing.
--
-- TODO: Rewrite to process file using native Lua methods.
-- TODO: Add support for yanking and inserting the object.
-- TODO: Refactor as generate_utils(), get_utils({yank, insert}), and update_utils_return().
local update_utils_return = function()
	nvim_exec(
		[[
    exe "normal G(dt}ddoreturn x\<Esc>r{"
    global/\-\-.*\nlocal/exe "normal j^wyiwGo\<Esc>pa = \<Esc>pax\<Esc>r,"
    exe "normal xox\<Esc>r}>T{"
  ]],
		false
	)
end

local create_scratch_buffer = function()
	return api.nvim_create_buf(false, true) -- Unlisted, scratch
end

local create_floating_window = function(opts)
	local opts = opts or { text = "", padding = 6 }
	local ui = vim.api.nvim_list_uis()[1]
	local width = ui.width - (opts.padding * 2)
	local height = ui.height - (opts.padding * 2)
	local buffer = create_scratch_buffer
	local window_options = {
		relative = "editor",
		style = "minimal",
		border = "shadow",
		width = width,
		height = height,
		row = opts.padding,
		col = opts.padding,
		zindex = 69,
		noautocmd = true,
	}

	return api.nvim_open_win(buffer, true, window_options)
end

-- Create a floating scratch window with the given contents, centered on screen
local create_scratch_window = function(text)
	return create_floating_window({ text = text, padding = 6 })
end

-- Save current session to file in a home directory. By default
-- ~/.vim-sessions/<cwd>_<name or "auto">.vim. E.g. running save_session() now saves my session at:
-- ~/.vim-sessions/etc_nixos_auto.vim, or ~/.vim-sessions/etc_nixos_utils.vim if {name = "utils"}.
local save_session = function(name)
	local name = name or "auto"
	local opts = opts or { dir = "~/.vim-sessions" }

	-- Name is empty string if running as Vim command with no argument
	if name == "" then
		name = "auto"
	end

	local file = vim.loop.cwd():gsub("/", "_"):sub(2) .. "_" .. name .. ".vim"
	local path = opts.dir .. "/" .. file

	-- Create session directory if it does not already exist
	if fn.empty(fn.glob(opts.dir)) > 0 then
		fn.system({
			"mkdir",
			"-p",
			opts.dir,
		})
	end

	nvim_exec("mksession! " .. path, false)
	echo("Saved session at " .. path)
end

-- Load a saved Vim session by name, simply sourcing it like any other mksession session file.
local load_session = function(name, opts)
	local name = name or "auto"
	local opts = opts or { dir = "~/.vim-sessions" }

	-- Name is empty string if running as Vim command with no argument
	if name == "" then
		name = "auto"
	end

	local file = vim.loop.cwd():gsub("/", "_"):sub(2) .. "_" .. name .. ".vim"
	local path = opts.dir .. "/" .. file

	nvim_exec("source " .. path, false)
	echo("Loaded session from " .. path)
end

-- Toggle boolean or other types of values under cursor
local toggle_word = function()
	local window = vim.api.nvim_get_current_win()
	local cursor = vim.api.nvim_win_get_cursor(window)
	local word = cword()
	local substitutions = {
		["margin"] = "padding",
		["px"] = "rem",

		["and"] = "or",
		["&&"] = "||",

		["up"] = "down",
		["Up"] = "Down",
		["UP"] = "DOWN",

		["left"] = "right",
		["Left"] = "Right",
		["LEFT"] = "RIGHT",

		["enabled"] = "disabled",
		["enable"] = "disable",

		["true"] = "false",
		["True"] = "False",
		["TRUE"] = "FALSE",

		["top"] = "bottom",
		["Top"] = "Bottom",
		["TOP"] = "BOTTOM",

		["yes"] = "no",
		["Yes"] = "No",
		["YES"] = "NO",

		["on"] = "off",
		["On"] = "Off",
		["ON"] = "OFF",

		["0"] = "1",
		["<"] = ">",
		["+"] = "-",
		["="] = "!=",
		["=="] = "!==",
	}

	vim.tbl_add_reverse_lookup(substitutions)

	if substitutions[word] ~= nil then
		nvim_exec("normal ciw" .. substitutions[word], true)
		vim.api.nvim_win_set_cursor(window, cursor)
	end
end

-- Returns the color set by the current colorscheme for the `attr` attribute of
-- the `hlgroup_name` highlight group in hexadecimal format.
--
-- Credit: https://github.com/noib3/nvim-cokeline
--
-- @param hlgroup_name  string
-- @param attr  '"fg"' | '"bg"'
-- @return string
local get_hex = function(hlgroup_name, attr)
	local hlgroup_id = fn.synIDtrans(fn.hlID(hlgroup_name))
	local hex = fn.synIDattr(hlgroup_id, attr)

	return hex ~= "" and hex or "NONE"
end

return {
	browsersearch = browsersearch,
	color = color,
	copy = copy,
	create_scratch_window = create_scratch_window,
	cword = cword,
	date = date,
	echo = echo,
	feedkeys = feedkeys,
	get_hex = get_hex,
	get_version = get_version,
	insert_line_and_toggle_comment = insert_line_and_toggle_comment,
	inspect = inspect,
	load_session = load_session,
	merge_tables = merge_tables,
	save_session = save_session,
	t = t,
	toggle_word = toggle_word,
	update_utils_return = update_utils_return,
}
