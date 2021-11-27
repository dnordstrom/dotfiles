----
-- UTILITIES
----

local M = {operators = {}}

-- Replace Vim termcodes in string
M.t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local t = M.t

-- Replace termcodes in string and feed as keys 
M.feedkeys = function(str)
  vim.api.nvim_feedkeys(t(str), "m", true)
end

-- Get Neovim version in `vX.X.X-dev` format
M.get_version = function()
  return vim.api.nvim_exec([[
    echo matchstr(execute("version"), "NVIM \\zs[^\\n]*")
  ]], true)
end

-- Get date/time
M.date = function(format)
  return os.date(format or "%Y-%m-%d %H:%M")
end

-- Inspect variablestables
M.inspect = function(var)
  print(vim.inspect(var))
end

-- Show a simple message
M.echo = function(message, highlight, label_highlight)
  local message = message or "Empty message."
  local highlight = highlight or "Comment"
  local label_highlight = label_highlight or "healthSuccess"

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

-- Get word under cursor
M.get_word = function()
  local first_line_num, last_line_num = vim.fn.getpos("'<")[2], vim.fn.getpos("'>")[2]
  local first_col, last_col = vim.fn.getpos("'<")[3], vim.fn.getpos("'>")[3]
  local current_word = vim.fn.getline(first_line_num, last_line_num)[1]:sub(first_col, last_col)

  return current_word
end

-- Web search operator
M.operators.browsersearch = function(mode)
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
M.browsersearch = function(query)
  local command = os.getenv("BROWSER") or "firefox"
  local url = "https://google.com/search?q="
  local tohex = function(char)
    return string.format("%%%02X", string.byte(char))
  end

  query = query:gsub("([^%w ])", tohex)
  query = query:gsub("%s+", "+")

  io.popen(command .. ' "' .. url .. query .. '"')
end

-- Insert a new line and toggle commenting with gcc (uses a temporarily inserted character
-- as workaround for plugins that don't allow comment toggling on blank lines
M.insert_line_and_toggle_comment = function(opts)
  local opts = opts or {above = false}
  local mode = vim.api.nvim_get_mode().mode
  local typekeys = function(str)
    -- Replace termcodes in string and feed result as typed keys 
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(str, true, false, true), "m", true)
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

return M
