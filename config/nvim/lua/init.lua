--
-- Reference
--


--
-- Imports
--

local lspconfig = require("lspconfig") -- Language server configuration tool
local npairs = require("nvim-autopairs") -- Pair brackets and similar
local luasnip = require("luasnip") -- Snippets

--
-- Helpers
--

-- Replace Vim termcodes in string
local function t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--
-- Shortcut variables
--

-- Keeping the original names instead of shortening them because it makes it 
-- easier to learn and remember them. The right hand side never uses other
-- shortcut variables since that could break if some are removed.

-- Options
local opt = vim.opt
local opt_local = vim.opt_local
local opt_global = vim.opt_global

-- Variables
local g = vim.g

-- API
local api = vim.api
local fn = vim.fn
local nvim_exec = vim.api.nvim_exec
local nvim_set_keymap = vim.api.nvim_set_keymap
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap

--
-- Local variables
--

local home = os.getenv("HOME")

--
-- Global variables
--

-- Accessed via `v:lua.NORDUtils.method()` or `<Cmd>lua NORDUtils.method()<CR>`
_G.NORDUtils = {operators = {}}

-- Shortcut
NORDUtils = _G.NORDUtils
_N = _G.NORDUtils

NORDUtils.smart_tab = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-n>");
  else
    return t("<Tab>");
  end
end

NORDUtils.smart_tab_shift = function()
  if vim.fn.pumvisible() ~= 0 then
    return t("<C-p>");
  else
    return t("<S-Tab>");
  end
end

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

-- Inspect variables such as tables
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

-- Reload configuration
-- Sources from `/etc/nixos` by default since it's usually used to test
-- configuration edits. Passing `false` sources from home directory.
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
-- Uses the function below to perform searches using web browser.
NORDUtils.operators.browsersearch = function(mode)
  if mode == nil then
    vim.go.operatorfunc = 'v:lua.NORDUtils.operators.browsersearch'
    vim.api.nvim_feedkeys('g@', 'n', false)
  end

  local command = "firefox"
  local url = "https://google.com/search?q="
  local start = vim.api.nvim_buf_get_mark(0, '[')
  local finish = vim.api.nvim_buf_get_mark(0, ']')
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

  io.popen(command .. " '" .. url .. query .. "'")
end

--
-- Options
--

vim.g.mapleader = " "

-- General
opt.ignorecase = true
opt.number = true
opt.relativenumber = true
opt.completeopt = "noinsert,menuone,noselect"
opt.mouse = "a"
opt.clipboard = "unnamedplus"

-- Explorer
g.netrw_liststyle = 4 -- Open in previous window
g.netrw_browse_split = 2 -- Split vertically
g.netrw_winsize = 25 -- In percent, ignored by `:Texplore` windows
g.netrw_altv = 1 -- Open file to the right
g.netrw_banner = 0 -- Hide banner

-- Formatting
opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2

-- Wrapping
opt.wrap = true -- Soft wrap
opt.wrapmargin = 80 -- Soft wrap column
opt.textwidth = 80 -- Hard wrap column when `formatoptions~=t` or `gq` is used
opt.formatoptions = 'cjroql'

-- Reference:
-- t -> auto-wrap at textwidth
-- c -> comments auto-wrap at textwidth
-- r -> auto-insert comment leader on <Enter>
-- o -> auto-insert comment leader on `o` and `O`
-- q -> allow `gq` formatting
-- j -> smart join comment lines
-- For hard wrap: tcjroql
-- For hard wrap comments only: cjroql

-- Theme
g.nord_contrast = true
g.nord_borders = false
g.nord_disable_background = true
g.nord_italic = true

require("nord").set()

--
-- Status line
--
require("lualine").setup{
  options = {
    icons_enabled = true,
    theme = "nord",
    component_separators = {"", ""},
    section_separators = {"", ""},
    disabled_filetypes = {"dashboard"}
  },
  sections = {
    lualine_a = {"mode"},
    lualine_b = {"branch"},
    lualine_c = {'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', "filename"},
    lualine_x = {"encoding", "fileformat", "filetype"},
    lualine_y = {"progress"},
    lualine_z = {"location"}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {"filename"},
    lualine_x = {"location"},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

--
-- Telescope
--

require("telescope").setup{
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case"
    },
    prompt_prefix = " ",
    selection_caret = "ﱣ ",
    entry_prefix = "ﱤ ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "descending",
    layout_strategy = "vertical",
    layout_config = {
      horizontal = {
        mirror = false,
      },
      vertical = {
        mirror = true,
      },
    },
    generic_sorter =  require("telescope.sorters").get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = {"─", "│", "─", "│", "╭", "╮", "╯", "╰"},
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = {["COLORTERM"] = "truecolor"}, -- default = nil,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    },
    frecency = {
      workspaces = {
        ["code"]    = "/home/dnordstrom/Code",
        ["nix"]    = "/etc/nixos",
        ["t"] = "/home/dnordstrom/Code/ticker",
        ["tb"]    = "/home/dnordstrom/Code/ticker-backend"
      }
    }
  },
}

require("telescope").load_extension("frecency")
require("telescope").load_extension("fzf")

--
-- Key maps
--

local opts = {
  nore = {noremap = true},
  noreExpr = {noremap = true, expr = true},
  noreSilent = {noremap = true, silent = true},
  noreSilentExpr = {noremap = true, silent = true, expr = true},
}

-- Reload config
nvim_set_keymap("n", "<Leader>rr", "<Cmd>lua NORDUtils.reload(true)<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>rR", "<Cmd>lua NORDUtils.reload(false)<CR>", opts.nore)

-- Save
nvim_set_keymap("n", "ZW", "<Cmd>w<CR>", opts.nore)

-- Insert mode navigation
nvim_set_keymap("i", "<C-h>", "<Left>", opts.nore)
nvim_set_keymap("i", "<C-j>", "<Down>", opts.nore)
nvim_set_keymap("i", "<C-k>", "<Up>", opts.nore)
nvim_set_keymap("i", "<C-l>", "<Right>", opts.nore)

-- Command mode navigation
nvim_set_keymap("c", "<C-a>", "<Home>", opts.nore)
nvim_set_keymap("c", "<C-e>", "<End>", opts.nore)
nvim_set_keymap("c", "<C-f>", "<Right>", opts.nore)
nvim_set_keymap("c", "<C-b>", "<Left>", opts.nore)
nvim_set_keymap("c", "<C-u>", "<End><C-u>", opts.nore)
nvim_set_keymap("c", "<M-l>", "<Home>lua print(vim.inspect(<End>))", opts.nore)
nvim_set_keymap("n", "<Leader>vi", ":lua print(vim.inspect())<Left><Left>", opts.nore)
nvim_set_keymap("n", "<Leader>vl", ":lua ", opts.nore)
nvim_set_keymap("n", "<Leader>vh", "<Cmd>help ", opts.nore)

-- Make `Y` behave like `D` and `C`, yanking to end of line
nvim_set_keymap("n", "Y", "y$", opts.nore)

-- Toggle sidebar
nvim_set_keymap("n", "<C-b>", "<Cmd>Lex<CR>", opts.nore)

-- Clear search highlights
nvim_set_keymap("n", "<Leader>h", "<Cmd>set hlsearch!<CR>", opts.nore)

-- Go to buffer
nvim_set_keymap("n", "gb", "<Cmd>ls<CR>:b<Space>", opts.nore)

-- Go to definition
nvim_set_keymap("n", "gD", "v:lua.vim.lsp.buf.declaration()", opts.noreExpr)
nvim_set_keymap("n", "gd", "v:lua.vim.lsp.buf.definition()", opts.noreExpr)
nvim_set_keymap("n", "F12", "v:lua.vim.lsp.buf.definition()", opts.noreExpr)
nvim_set_keymap("i", "F12", "v:lua.vim.lsp.buf.definition()", opts.noreExpr)

-- Telescope
nvim_set_keymap("n", "<Leader>ff", '<Cmd>lua require("telescope.builtin").fd()<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>fg", '<Cmd>lua require("telescope.builtin").live_grep()<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>fe", '<Cmd>lua require("telescope.builtin").file_browser()<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>fb", '<Cmd>lua require("telescope.builtin").buffers()<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>fh", '<Cmd>lua require("telescope.builtin").help_tags()<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>fs", '<Cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', opts.nore)
nvim_set_keymap("n", "<Leader>fd", '<Cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts.nore)
nvim_set_keymap("n", "<Leader><Leader>", '<Cmd>lua require"telescope".extensions.frecency.frecency()<CR>', opts.nore)
nvim_set_keymap("n", "<C-Space>", '<Cmd>lua require"telescope".extensions.frecency.frecency()<CR>', opts.nore)

-- Diagnostic
nvim_set_keymap("n", "<Leader>dd", "<Cmd>TroubleToggle lsp_document_diagnostics<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dn", "v:lua.vim.lsp.diagnostic.goto_prev()", opts.noreExpr)
nvim_set_keymap("n", "<Leader>dN", "v:lua.vim.lsp.diagnostic.goto_next()", opts.noreExpr)
nvim_set_keymap("n", "<Leader>dl", "v:lua.vim.lsp.diagnostic.show_line_diagnostics({focusable = false})", opts.noreExpr)

-- Dashboard
nvim_set_keymap("n", "<Leader>vh", "<Cmd>DashboardFindHistory<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>vf", "<Cmd>DashboardFindFile<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>vc", "<Cmd>DashboardChangeColorscheme<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>va", "<Cmd>DashboardFindWord<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>vm", "<Cmd>DashboardJumpMark<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>vn", "<Cmd>DashboardNewFile<CR>", opts.nore)

-- NCM2

nvim_set_keymap("i", "<Tab>", "v:lua.NORDUtils.smart_tab()", opts.noreExpr)
nvim_set_keymap("i", "<S-Tab>", "v:lua.NORDUtils.smart_tab_shift()", opts.noreExpr)
nvim_set_keymap("i", "<CR>", "v:lua.NORDUtils.smart_return()", opts.noreExpr)

-- Custom operators
nvim_set_keymap("n", "<Leader>gs", "<Cmd>lua NORDUtils.operators.browsersearch()<CR>", opts.nore)

--
-- Plugins
--

-- Show possible key binds when typing
require("which-key").setup({})

-- Line peek
require("numb").setup()

-- Comment labels
require("todo-comments").setup {
  -- All options can be found here:
  -- https://github.com/folke/todo-comments.nvim/blob/main/lua/todo-comments/config.lua

  -- Example extending existing keywords:
  --   keywords = {
  --     WARN = {icon = " ", color = "warning", alt = {"@warn", "@WARNING", "warning", "WARNING", "XXX"}},
  --   }
}

-- Autopairs
require("nvim-autopairs").setup({
  disable_filetype = {"TelescopePrompt", "dashboard"},
  check_ts = true,
})

-- Dashboard

g.dashboard_preview_command = "bat"
g.dashboard_default_executive = "telescope"
g.dashboard_custom_footer = {"  Neovim " .. NORDUtils.nvim_version}

nvim_exec([[
  augroup dashboard
    autocmd!
    autocmd User TelescopePreviewerLoaded setlocal wrap
    autocmd FileType dashboard set showtabline=0
    autocmd WinLeave <Buffer> set showtabline=2
  augroup end

  augroup yankhighlight
    autocmd!
    autocmd TextYankPost * silent! lua vim.highlight.on_yank({ timeout = 100 })
  augroup end
]], false)

--
-- Language Server Protocols
--

-- Runs after the servers have attached to a buffer
local on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    nvim_buf_set_keymap(bufnr, "n", "<Leader>df", "vim.lsp.buf.formatting()", opts.nore)
  elseif client.resolved_capabilities.document_range_formatting then
    nvim_buf_set_keymap(bufnr, "n", "<Leader>df", "vim.lsp.buf.range_formatting()", opts.nore)
  end
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Load a list of langauge servers instead of each individually
local servers = {"html", "tsserver", "cssls", "jsonls", "bashls", "gopls"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities
  })
end

nvim_exec([[
    autocmd CursorHold silent! lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})
]], false)

lspconfig.diagnosticls.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = {"javascript", "typescript"},
  root_dir = function(fname)
    return lspconfig.util.root_pattern("tsconfig.json")(fname) or
    lspconfig.util.root_pattern(".eslintrc.js")(fname);
  end,
  init_options = {
    linters = {
      eslint = {
        command = "./node_modules/.bin/eslint",
        rootPatterns = {".eslintrc.js", ".git"},
        debounce = 100,
        args = {
          "--stdin",
          "--stdin-filename",
          "%filepath",
          "--format",
          "json"
        },
        sourceName = "eslint",
        parseJson = {
          errorsRoot = "[0].messages",
          line = "line",
          column = "column",
          endLine = "endLine",
          endColumn = "endColumn",
          message = "[eslint] ${message} [${ruleId}]",
          security = "severity"
        },
        securities = {
          [2] = "error",
          [1] = "warning"
        }
      },
    },
    filetypes = {
      javascript = "eslint",
      typescript = "eslint"
    }
  }
}
-- For EFM language server with `eslint_d`, see:
-- https://github.com/neovim/nvim-lspconfig/wiki/User-contributed-tips#eslint_d

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
  }
)

-- Requires patched font
local signs = {
  Error = " ",
  Warning = " ",
  Hint = " ",
  Information = " ",
}

for type, icon in pairs(signs) do
  local hl = "LspDiagnosticsSign" .. type

  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = "",
  })
end

require("trouble").setup{
  mode = "lsp_document_diagnostics",
  use_lsp_diagnostic_signs = true,
}

--
-- Finalize global variables
--

-- Source or view configurations either live from `/etc/nixos` to test before
-- builds, or the currently installed configuration in `~/.config`. Setting
-- `live` to `true` will source the live configuration.
NORDUtils.config_reload = function(live)
  if live == true then
    require("/etc/nixos/config/nvim/lua/init.lua")
  else
    -- `~/.config/nvim/init.lua` is generated by Home Manager and just loads
    -- the following `~/.config/nvim/lua/init.lua`.
    require(home .. "/.config/nvim/lua/init.lua")
  end
end

--
-- Vim script
--

nvim_exec([[
  autocmd BufEnter * call ncm2#enable_for_buffer()

  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require("vim.highlight").on_yank({timeout = 100})
  augroup end
]], false)
