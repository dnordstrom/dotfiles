--
-- Variables
--

local g = vim.g
local o = vim.opt
local api = vim.api
local exec = api.nvim_exec
local nvim_set_keymap = api.nvim_set_keymap
local nvim_buf_set_keymap = api.nvim_buf_set_keymap
local home = os.getenv('HOME')
local version = vim.api.nvim_exec([[
  echo matchstr(execute('version'), 'NVIM \zs[^\n]*')
]], true)

vim.api.nvim_set_var('nordix_nvim_version', version)

--
-- Options
--

g.mapleader = ' '

-- General
o.backup = false
o.writebackup = false
o.ignorecase = true
o.number = true
o.relativenumber = true
o.swapfile = false
o.completeopt = 'menuone,noinsert'

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

require'nord'.set()

require'lualine'.setup{
  options = {
    icons_enabled = true,
    theme = 'nord',
    component_separators = {'', ''},
    section_separators = {'', ''},
    disabled_filetypes = { 'dashboard' }
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {'vim.fn.fnamemodify(vim.fn.getcwd(), ":t")', 'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  extensions = {}
}

--
-- Telescope
--

require'telescope'.setup{
  defaults = {
    vimgrep_arguments = {
      'rg',
      '--color=never',
      '--no-heading',
      '--with-filename',
      '--line-number',
      '--column',
      '--smart-case'
    },
    prompt_prefix = ' ',
    selection_caret = 'ﱣ ',
    entry_prefix = 'ﱤ ',
    initial_mode = 'insert',
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
    generic_sorter =  require'telescope.sorters'.get_generic_fuzzy_sorter,
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    path_display = {},
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
    grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
    qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,

    -- Developer configurations: Not meant for general override
    buffer_previewer_maker = require'telescope.previewers'.buffer_previewer_maker
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
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

require"telescope".load_extension('frecency')
require'telescope'.load_extension('fzf')

--
-- Autocomplete
--

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;

  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' },
    winhighlight = 'NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder',
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    buffer = true;
    calc = true;
    luasnip = true;
    nvim_lsp = true;
    nvim_lua = true;
    path = true;
    treesitter = true;
    ultisnips = true;
    vsnip = true;
  };
}


---- Helpers

local termcodes = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.' - 1)
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s' ~= nil)
end

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return termcodes '<C-n>'
  elseif check_back_space() then
    return termcodes '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.shift_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return termcodes '<C-p>'
  else
    return termcodes '<S-Tab>'
  end
end

--
-- Global Key Maps
--

local opts = { noremap = true, silent = true }
local exprOpts = { noremap = true, silent = true, expr = true }

---- Insert mode navigation
nvim_set_keymap('i', '<C-h>', '<Left>', opts)
nvim_set_keymap('i', '<C-j>', '<Down>', opts)
nvim_set_keymap('i', '<C-k>', '<Up>', opts)
nvim_set_keymap('i', '<C-l>', '<Right>', opts)

---- Make `Y` behave like `D` and `C`, yanking to end of line
nvim_set_keymap('n', 'Y', 'y$', opts)

---- Toggle sidebar
nvim_set_keymap('n', '<C-b>', '<Cmd>NERDTreeToggle<CR>', opts)

---- Clear search highlights
nvim_set_keymap('n', '<Leader>h', '<Cmd>set hlsearch!<CR>', opts)

---- Go to buffer
nvim_set_keymap('n', 'gb', '<Cmd>ls<CR><Cmd>b<Space>', opts)

---- Go to definition
nvim_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
nvim_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
nvim_set_keymap('n', 'F12', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
nvim_set_keymap('i', 'F12', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

---- Autocomplete
-- nvim_set_keymap('i', '<CR>', 'compe#confirm("<CR>")', exprOpts)
nvim_set_keymap('i', '<S-Space>', 'compe#complete()', exprOpts)
nvim_set_keymap('i', '<S-C-Space>', 'compe#close()', exprOpts)
nvim_set_keymap('i', '<Tab>', 'v:lua.tab_complete()', exprOpts)
nvim_set_keymap('s', '<Tab>', 'v:lua.tab_complete()', exprOpts)
nvim_set_keymap('i', '<S-Tab>', 'v:lua.shift_tab_complete()', exprOpts)
nvim_set_keymap('s', '<S-Tab>', 'v:lua.shift_tab_complete()', exprOpts)

-- Telescope
nvim_set_keymap('n', '<Leader>ff', '<Cmd>lua require"telescope.builtin".fd()<CR>', opts)
nvim_set_keymap('n', '<Leader>fg', '<Cmd>lua require"telescope.builtin".live_grep()<CR>', opts)
nvim_set_keymap('n', '<Leader>fe', '<Cmd>lua require"telescope.builtin".file_browser()<CR>', opts)
nvim_set_keymap('n', '<Leader>fb', '<Cmd>lua require"telescope.builtin".buffers()<CR>', opts)
nvim_set_keymap('n', '<Leader>fh', '<Cmd>lua require"telescope.builtin".help_tags()<CR>', opts)
nvim_set_keymap('n', '<Leader>fs', '<Cmd>lua require"telescope.builtin".lsp_document_symbols()<CR>', opts)
nvim_set_keymap('n', '<Leader>fd', '<Cmd>lua require"telescope.builtin".lsp_definitions()<CR>', opts)
nvim_set_keymap('n', '<Leader><Leader>', '<Cmd>lua require"telescope".extensions.frecency.frecency()<CR>', opts)
nvim_set_keymap('n', '<C-Space>', '<Cmd>lua require"telescope".extensions.frecency.frecency()<CR>', opts)

-- Diagnostic
nvim_set_keymap('n', '<Leader>dd', '<Cmd>TroubleToggle lsp_document_diagnostics<CR>', opts)
nvim_set_keymap('n', '<Leader>dn', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
nvim_set_keymap('n', '<Leader>dN', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
nvim_set_keymap('n', '<Leader>dl', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })<CR>', opts)

-- Dashboard
nvim_set_keymap('n', '<Leader>vh', '<Cmd>DashboardFindHistory<CR>', opts)
nvim_set_keymap('n', '<Leader>vf', '<Cmd>DashboardFindFile<CR>', opts)
nvim_set_keymap('n', '<Leader>vc', '<Cmd>DashboardChangeColorscheme<CR>', opts)
nvim_set_keymap('n', '<Leader>va', '<Cmd>DashboardFindWord<CR>', opts)
nvim_set_keymap('n', '<Leader>vm', '<Cmd>DashboardJumpMark<CR>', opts)
nvim_set_keymap('n', '<Leader>vn', '<Cmd>DashboardNewFile<CR>', opts)

--
-- Plugins
--

require('numb').setup()

-- Autopairs
require('nvim-autopairs').setup({
  disable_filetype = { 'TelescopePrompt' },
})
require'nvim-autopairs.completion.compe'.setup({
  map_cr = true,
  map_complete = true,
  auto_select = false,
})

-- Dashboard

g.dashboard_preview_command = 'bat'
g.dashboard_default_executive = 'telescope'
g.dashboard_custom_footer = { ' Neovim ' .. version }

vim.api.nvim_exec([[
  augroup init_dashboard
    autocmd!
    autocmd User TelescopePreviewerLoaded setlocal wrap
    autocmd FileType dashboard set showtabline=0
    autocmd WinLeave <Buffer> set showtabline=2
  augroup end

  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({ timeout = 100 })
  augroup end
]], false)

--
-- Language Servers
--

local on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>df', 'vim.lsp.buf.formatting()', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>df', 'vim.lsp.buf.range_formatting()', opts)
  end
end

lspconfig = require'lspconfig'

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = { 'html', 'tsserver', 'cssls', 'jsonls', 'bashls', 'gopls' }
for _, lsp in ipairs(servers) do
  require('lspconfig')[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

vim.api.nvim_exec([[
    autocmd CursorHold silent! lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })
]], false)

require('compe').setup {
  source = {
    path = true,
    nvim_lsp = true,
    luasnip = true,
    buffer = true,
    calc = false,
    nvim_lua = false,
    vsnip = false,
    ultisnips = false,
  },
}

-- Utility functions for compe and luasnip
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col '.' - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match '%s' then
    return true
  else
    return false
  end
end

local luasnip = require 'luasnip'

_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-n>'
  elseif luasnip.expand_or_jumpable() then
    return t '<Plug>luasnip-expand-or-jump'
  elseif check_back_space() then
    return t '<Tab>'
  else
    return vim.fn['compe#complete']()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t '<C-p>'
  elseif luasnip.jumpable(-1) then
    return t '<Plug>luasnip-jump-prev'
  else
    return t '<S-Tab>'
  end
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

vim.lsp.handlers['textDocument/publishDiagnostics'] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false
  }
)

-- Requires patched font
local signs = {
  Error = " ",
  Warning = " ",
  Hint = " ",
  Information = " "
}

for type, icon in pairs(signs) do
  local hl = 'LspDiagnosticsSign' .. type

  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = ''
  })
end

require'trouble'.setup{
  mode = "lsp_document_diagnostics",
  use_lsp_diagnostic_signs = true
}

--
-- Vim script
--

vim.api.nvim_exec([[
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank({ timeout = 100 })
  augroup end
]], false)
