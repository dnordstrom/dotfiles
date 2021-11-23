--
-- Utilities
--

-- Replace Vim termcodes in string
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

_G.t = t
_G.NORDUtils = {operators = {}}
NORDUtils = _G.NORDUtils

-- Next or Tab depending on if menu is open
NORDUtils.smart_tab = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-n>");
  else
    return t("<Tab>");
  end
end

-- Previous or Shift-Tab depending on if menu is open
NORDUtils.smart_tab_shift = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-p>");
  else
    return t("<S-Tab>");
  end
end

-- Return or accept completion depending on if menu is open
NORDUtils.smart_return = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-y>"); -- Complete without appending newline
  else
    return t("<CR>");
  end
end

-- Neovim version string in `v0.6.0` format
NORDUtils.nvim_version = vim.api.nvim_exec([[
  echo matchstr(execute("version"), "NVIM \\zs[^\\n]*")
]], true)

-- Inspect variablestables
NORDUtils.inspect = function(var)
  print(vim.inspect(var))
end

-- Show a simple message
NORDUtils.echo = function(message, highlight, label_highlight)
  label = "NORDUtils"
  message = message or "Empty message."

  highlight = highlight or "Comment"
  label_highlight = label_highlight or "healthSuccess"

  vim.api.nvim_echo(
    {
      { "\r\rNORDUtils", label_highlight },
      { ": ", highlight },
      { message, highlight }
    },
    true,
    {}
  )
end

-- Reload configuration from `/etc/nixos` by default, home directory if live is false
NORDUtils.reload = function(live)
  if live == false then
    api.nvim_command("source " .. home .. "/.config/nvim/lua/init.lua")
    NORDUtils.echo("Home configuration reloaded.")
  else
    api.nvim_command("source /etc/nixos/config/nvim/lua/init.lua")
    NORDUtils.echo("Live configuration reloaded.")
  end
end

-- Get word under cursor
NORDUtils.get_word = function()
  local first_line_num, last_line_num = vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2]
  local first_col, last_col = vim.fn.getpos("'<")[3], vim.fn.getpos("'>")[3]
  local current_word = vim.fn.getline(first_line_num, last_line_num)[1]:sub(first_col, last_col)

  return current_word
end

-- Web search operator
NORDUtils.operators.browsersearch = function(mode)
  if mode == nil then
    vim.go.operatorfunc = "v:lua.NORDUtils.operators.browsersearch"
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

  NORDUtils.browsersearch(query)
end

-- Web search

NORDUtils.browsersearch = function(query)
  local command = "firefox"
  local url = "https://google.com/search?q="
  local tohex = function(char)
    return string.format("%%%02X", string.byte(char))
  end

  query = query:gsub("([^%w ])", tohex)
  query = query:gsub("%s+", "+")

  io.popen(command .. ' "' .. url .. query .. '"')
end

