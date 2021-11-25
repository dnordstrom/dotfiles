--
-- Utilities
--

_G.utils = {
  operators = {}
}

-- Replace Vim termcodes in string
_G.utils.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local t = _G.utils.t

-- Next or Tab depending on if menu is open (not used since nvim-cmp has its own methods)
_G.utils.smart_tab = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-n>");
  else
    return t("<Tab>");
  end
end

-- Previous or Shift-Tab depending on if menu is open (not used since nvim-cmp has its own methods)
_G.utils.smart_tab_shift = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-p>");
  else
    return t("<S-Tab>");
  end
end

-- Return or accept depending on if menu is open (not used since nvim-cmp has its own methods)
_G.utils.smart_return = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-y>"); -- Complete without appending newline
  else
    return t("<CR>");
  end
end

-- Neovim version string in `v0.6.0` format
_G.utils.nvim_version = vim.api.nvim_exec([[
  echo matchstr(execute("version"), "NVIM \\zs[^\\n]*")
]], true)

-- Get date/time
_G.utils.date = function(format)
  return os.date(format or '%Y-%m-%d %H:%M')
end

-- Inspect variablestables
_G.utils.inspect = function(var)
  print(vim.inspect(var))
end

-- Show a simple message
_G.utils.echo = function(message, highlight, label_highlight)
  local message = message or "Empty message."
  local highlight = highlight or "Comment"
  local label_highlight = label_highlight or "healthSuccess"

  vim.api.nvim_echo(
    {
      { "\r\rNORD_G.utils", label_highlight },
      { ": ", highlight },
      { message, highlight }
    },
    true,
    {}
  )
end

-- Reload configuration from `/etc/nixos` by default, home directory if live is false
_G.utils.reload = function(live)
  local options = options or {live = false}

  if options.live == false then
    vim.api.nvim_command("source " .. home .. "/.config/nvim/lua/init.lua")
    M.echo("Home configuration reloaded.")
  else
    vim.api.nvim_command("source /etc/nixos/config/nvim/lua/init.lua")
    M.echo("Live configuration reloaded.")
  end
end

-- Get word under cursor
_G.utils.get_word = function()
  local first_line_num, last_line_num = vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2]
  local first_col, last_col = vim.fn.getpos("'<")[3], vim.fn.getpos("'>")[3]
  local current_word = vim.fn.getline(first_line_num, last_line_num)[1]:sub(first_col, last_col)

  return current_word
end

-- Web search operator
_G.utils.operators.browsersearch = function(mode)
  if mode == nil then
    vim.go.operatorfunc = "v:lua.M.operators.browsersearch"
    vim.api.nvim_feedkeys("g@", "n", false)
  end

  local command = "firefox"
  local url = "https://google.com/search?q="
  local start = vim.api.nvim_buf_get_mark(0, "[")
  local finish = vim.api.nvim_buf_get_mark(0, "]")
  local lines = vim.api.nvim_buf_get_lines(0, start[1] - 1, finish[1], false)
  local query

  if #lines > 1 then
    query = table.concat(lines, " ")
  else
    query = lines[1]:sub(start[2] + 1, finish[2] + 1)
  end

  M.browsersearch(query)
end

-- Web search
_G.utils.browsersearch = function(query)
  local command = os.getenv("BROWSER") or "firefox"
  local url = "https://google.com/search?q="
  local tohex = function(char)
    return string.format("%%%02X", string.byte(char))
  end

  query = query:gsub("([^%w ])", tohex)
  query = query:gsub("%s+", "+")

  io.popen(command .. ' "' .. url .. query .. '"')
end

