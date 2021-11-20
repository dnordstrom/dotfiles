--
-- Imports
--

require ("plugins")

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
-- Sources from `/etc/nixos` by default since it"s usually used to test
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
opt.wrapmargin = 100 -- Soft wrap column
-- opt.textwidth = 100 -- Hard wrap column when `formatoptions~=t` or `gq` is used
opt.formatoptions = "cjroql"

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
-- Plugins
--

-- Kommentary
require("kommentary.config").use_extended_mappings()

-- Show possible key binds when typing
require("which-key").setup({})

-- Comment labels
require("todo-comments").setup({})

-- Autopairs
require("nvim-autopairs").setup({
  check_ts = true,
})

-- Trouble
require("trouble").setup({
  mode = "lsp_document_diagnostics",
  use_lsp_diagnostic_signs = true,
})

-- Status line
require("feline").setup()

-- Completion
local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<TAB>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<S-TAB>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" })
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
  }, {
    { name = "buffer" },
  })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" }
  }
})

-- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  })
})

-- Renamer

local mappings_utils = require('renamer.mappings.utils')

require('renamer').setup {
  -- The popup title, shown if `border` is true
  title = 'Rename',
  -- The padding around the popup content
  padding = {
      top = 0,
      left = 0,
      bottom = 0,
      right = 0,
  },
  -- Whether or not to shown a border around the popup
  border = true,
  -- The characters which make up the border
  border_chars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  -- Whether or not to highlight the current word references through LSP
  show_refs = true,
  -- Whether or not to add resulting changes to the quickfix list
  with_qf_list = true,
  -- Whether or not to enter the new name through the UI or Neovim's `input`
  -- prompt
  with_popup = true,
  -- The keymaps available while in the `renamer` buffer. The example below
  -- overrides the default values, but you can add others as well.
  mappings = {
      ['<c-i>'] = mappings_utils.set_cursor_to_start,
      ['<c-a>'] = mappings_utils.set_cursor_to_end,
      ['<c-e>'] = mappings_utils.set_cursor_to_word_end,
      ['<c-b>'] = mappings_utils.set_cursor_to_word_start,
      ['<c-c>'] = mappings_utils.clear_line,
      ['<c-u>'] = mappings_utils.undo,
      ['<c-r>'] = mappings_utils.redo,
  },
  -- Custom handler to be run after successfully renaming the word. Receives
  -- the LSP 'textDocument/rename' raw response as its parameter.
  handler = nil,
}

-- Colorizer
require("colorizer").setup()

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

-- Move by line even when soft wrapped
nvim_set_keymap("n", "j", "gj", opts.nore)
nvim_set_keymap("n", "k", "gk", opts.nore)

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

-- FZF
nvim_set_keymap("n", "<Leader>ff", "<Cmd>FzfLua files<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fg", "<Cmd>FzfLua grep<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fl", "<Cmd>FzfLua live_grep<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>ft", "<Cmd>FzfLua tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fm", "<Cmd>FzfLua marks<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fc", "<Cmd>FzfLua commands<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fh", "<Cmd>FzfLua help_tags<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>fz", "<Cmd>FzfLua<CR>", opts.nore)

-- Diagnostic
nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts.nore)
nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("i", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dN", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dn", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts.nore)
nvim_set_keymap("n", "<Leader>dd", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts.nore)

-- Custom operators
nvim_set_keymap("n", "<Leader>gs", "<Cmd>lua NORDUtils.operators.browsersearch()<CR>", opts.nore)

-- Renamer
nvim_set_keymap('i', '<F2>', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('n', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)
nvim_set_keymap('v', '<Leader>rn', '<Cmd>lua require("renamer").rename({empty = false})<CR>', opts.noreSilent)

--
-- Language Server Protocols
--

local lspconfig = require("lspconfig") -- Language server configuration tool

-- Runs after the servers have attached to a buffer
local on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    nvim_buf_set_keymap(bufnr, "n", "<Leader>df", "vim.lsp.buf.formatting()", opts.nore)
  elseif client.resolved_capabilities.document_range_formatting then
    nvim_buf_set_keymap(bufnr, "n", "<Leader>df", "vim.lsp.buf.range_formatting()", opts.nore)
  end
end

-- Use nvim-cmp capabilities for completion
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())

capabilities.textDocument.completion.completionItem.snippetSupport = true

-- Load a list of langauge servers instead of each individually
local servers = {"html", "tsserver", "cssls", "jsonls", "bashls", "gopls"}
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities
  })
end

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

--
-- Vimscript
--

nvim_exec([[
  augroup line_diagnostics
    autocmd!
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
  augroup end

  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require("vim.highlight").on_yank({timeout = 100})
  augroup end
]], false)
