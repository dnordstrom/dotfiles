--
-- Imports
--

local lspconfig = require("lspconfig") -- Language server configuration tool
local npairs = require("nvim-autopairs") -- Pair brackets and similar
local luasnip = require("luasnip") -- Snippets

--
-- Global Variables
--

-- Accessed via `v:lua.NORDUtils.method()` or `<Cmd>lua NORDUtils.method()<CR>`
_G.NORDUtils = {}

-- Shortcut
NORDUtils = _G.NORDUtils

-- Autopair
NORDUtils.autopair = function()
  if vim.fn.pumvisible() ~= 0  then
      return npairs.esc("<CR>")
  else
    return npairs.autopairs_cr()
  end
end

-- Neovim version string in `v0.6.0` format
NORDUtils.nvim_version = vim.api.nvim_exec([[
  echo matchstr(execute("version"), "NVIM \zs[^\n]*")
]], true)

--
-- Local Variables
--

-- Common namespaces
local g = vim.g
local o = vim.opt
local api = vim.api

-- Skip namespaces (keep original name)
local nvim_exec = api.nvim_exec
local nvim_set_keymap = api.nvim_set_keymap
local nvim_buf_set_keymap = api.nvim_buf_set_keymap

-- Other variables
local home = os.getenv("HOME")

--
-- Options
--

g.mapleader = " "

-- General
o.backup = false
o.writebackup = false
o.ignorecase = true
o.number = true
o.relativenumber = true
o.swapfile = false
o.completeopt = "menuone,noinsert"
o.mouse = "a"

-- Formatting
o.autoindent = true
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2
o.textwidth = 80

-- Theme
g.nord_contrast = true
g.nord_borders = false
g.nord_disable_background = true
g.nord_italic = true

require("nord").set()

-- Status line
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
-- Global key maps
--

local opts = {
  normal = {noremap = true},
  silent = {noremap = true, silent = true},
  normalExpr = {noremap = true, expr = true},
  silentExpr = {noremap = true, silent = true, expr = true},
}

---- Insert mode navigation
nvim_set_keymap("i", "<C-h>", "<Left>", opts.silent)
nvim_set_keymap("i", "<C-j>", "<Down>", opts.silent)
nvim_set_keymap("i", "<C-k>", "<Up>", opts.silent)
nvim_set_keymap("i", "<C-l>", "<Right>", opts.silent)

---- Make `Y` behave like `D` and `C`, yanking to end of line
nvim_set_keymap("n", "Y", "y$", opts.silent)

---- Toggle sidebar
nvim_set_keymap("n", "<C-b>", "<Cmd>NERDTreeToggle<CR>", opts.silent)

---- Clear search highlights
nvim_set_keymap("n", "<Leader>h", "<Cmd>set hlsearch!<CR>", opts.silent)

---- Go to buffer
nvim_set_keymap("n", "gb", "<Cmd>ls<CR><Cmd>b<Space>", opts.silent)

---- Go to definition
nvim_set_keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts.silent)
nvim_set_keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.silent)
nvim_set_keymap("n", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.silent)
nvim_set_keymap("i", "F12", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts.silent)

---- Auto pair
nvim_set_keymap("i", "<CR>", "<Cmd>lua NORDUtils.autojoin()<CR>", opts.silent)

-- Telescope
nvim_set_keymap("n", "<Leader>ff", '<Cmd>lua require("telescope.builtin").fd()<CR>', opts.silent)
nvim_set_keymap("n", "<Leader>fg", '<Cmd>lua require("telescope.builtin").live_grep()<CR>', opts.silent)
nvim_set_keymap("n", "<Leader>fe", '<Cmd>lua require("telescope.builtin").file_browser()<CR>', opts.silent)
nvim_set_keymap("n", "<Leader>fb", '<Cmd>lua require("telescope.builtin").buffers()<CR>', opts.silent)
nvim_set_keymap("n", "<Leader>fh", '<Cmd>lua require("telescope.builtin").help_tags()<CR>', opts.silent)
nvim_set_keymap("n", "<Leader>fs", '<Cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', opts.silent)
nvim_set_keymap("n", "<Leader>fd", '<Cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts.silent)
nvim_set_keymap("n", "<Leader><Leader>", '<Cmd>lua require"telescope".extensions.frecency.frecency()<CR>', opts.silent)
nvim_set_keymap("n", "<C-Space>", '<Cmd>lua require"telescope".extensions.frecency.frecency()<CR>', opts.silent)

-- Diagnostic
nvim_set_keymap("n", "<Leader>dd", "<Cmd>TroubleToggle lsp_document_diagnostics<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>dn", "<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>dN", "<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>dl", "<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({focusable = false})<CR>", opts.silent)

-- Dashboard
nvim_set_keymap("n", "<Leader>vh", "<Cmd>DashboardFindHistory<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>vf", "<Cmd>DashboardFindFile<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>vc", "<Cmd>DashboardChangeColorscheme<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>va", "<Cmd>DashboardFindWord<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>vm", "<Cmd>DashboardJumpMark<CR>", opts.silent)
nvim_set_keymap("n", "<Leader>vn", "<Cmd>DashboardNewFile<CR>", opts.silent)

--
-- Plugins
--

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
g.dashboard_custom_footer = {" Neovim " .. NORDUtils.nvim_version}

nvim_exec([[
  augroup init_dashboard
    autocmd!
    autocmd User TelescopePreviewerLoaded setlocal wrap
    autocmd FileType dashboard set showtabline=0
    autocmd WinLeave <Buffer> set showtabline=2
  augroup end

  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require("vim.highlight").on_yank({timeout = 100})
  augroup end
]], false)

--
-- Language Server Protocols
--

-- Runs after the servers have attached to a buffer
local on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    nvim_buf_set_keymap(bufnr, "n", "<Leader>df", "vim.lsp.buf.formatting()", opts.silent)
  elseif client.resolved_capabilities.document_range_formatting then
    nvim_buf_set_keymap(bufnr, "n", "<Leader>df", "vim.lsp.buf.range_formatting()", opts.silent)
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
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require("vim.highlight").on_yank({timeout = 100})
  augroup end
]], false)
