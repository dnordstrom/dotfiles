--
-- Shortcuts
--

local g = vim.g
local o = vim.opt

--
-- Settings
--

g.mapleader = ' '

o.backup = false
o.writebackup = false
o.ignorecase = true
o.number = true
o.relativenumber = true
o.swapfile = false

--
-- Theme
--

g.nord_contrast = true
g.nord_borders = false
g.nord_disable_background = true
g.nord_italic = true

require('nord').set()

require('lualine').setup {
  options = {
    theme = 'nord'
  }
}

--
-- Formatting
--

o.autoindent = true
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

--
-- Telescope
--

require('telescope').setup{
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = 'smart_case',
    }
  },
  initial_mode = 'insert',
  file_previewer = require'telescope.previewers'.vim_buffer_cat.new,
  grep_previewer = require'telescope.previewers'.vim_buffer_vimgrep.new,
  qflist_previewer = require'telescope.previewers'.vim_buffer_qflist.new,
}

require('telescope').load_extension('fzf')

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
  local col = vim.fn.col('.') - 1
  return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
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

local remap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

---- Toggle sidebar
remap('n', '<C-b>', ':NERDTreeToggle<CR>', opts)

---- Clear search highlights
remap('n', '<Leader><h>', ':set hlsearch!<CR>', opts)

---- Go to buffer
remap('n', 'gb', ':ls<CR>:b<Space>', opts)

---- Go to definition
remap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
remap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
remap('n', 'F12', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
remap('i', 'F12', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

---- Autocomplete
remap('i', '<S-Space>', 'compe#complete()', opts)
remap('i', '<S-C-Space>', 'compe#close()', opts)
remap('i', '<Tab>', 'v:lua.tab_complete()', opts)
remap('s', '<Tab>', 'v:lua.tab_complete()', opts)
remap('i', '<S-Tab>', 'v:lua.shift_tab_complete()', opts)
remap('s', '<S-Tab>', 'v:lua.shift_tab_complete()', opts)

-- Telescope
remap('n', '<Leader>ff', '<Cmd>lua require("telescope.builtin").fd()<CR>', opts)
remap('n', '<Leader>fg', '<Cmd>lua require("telescope.builtin").live_grep()<CR>', opts)
remap('n', '<Leader>fe', '<Cmd>lua require("telescope.builtin").file_browser()<CR>', opts)
remap('n', '<Leader>fb', '<Cmd>lua require("telescope.builtin").buffers()<CR>', opts)
remap('n', '<Leader>fh', '<Cmd>lua require("telescope.builtin").help_tags()<CR>', opts)
remap('n', '<Leader>fs', '<Cmd>lua require("telescope.builtin").lsp_document_symbols()<CR>', opts)
remap('n', '<Leader>fd', '<Cmd>lua require("telescope.builtin").lsp_definitions()<CR>', opts)
remap('n', '<Leader><Space>', '<Cmd>lua require("telescope.builtin").builtin()<CR>', opts)
remap('n', '<C-Space>', '<Cmd>lua require("telescope.builtin").builtin()<CR>', opts)

-- Diagnostic
remap('n', '<Leader>dd', '<Cmd>:TroubleToggle lsp_document_diagnostics<CR>', opts)
remap('n', '<Leader>dn', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
remap('n', '<Leader>dN', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
remap('n', '<Leader>dl', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })<CR>', opts)

--
-- Language Servers
--

local on_attach = function(client, bufnr)
  if client.resolved_capabilities.document_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>df', '<Cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  elseif client.resolved_capabilities.document_range_formatting then
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<Leader>df', '<Cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
  end

  -- Show information on hover
  if client.resolved_capabilities.signature_help then
    vim.api.nvim_exec([[
      autocmd CursorHold * silent! lua vim.lsp.diagnostic.show_line_diagnostics({ focusable = false })
      autocmd CursorHoldI * silent! lua vim.lsp.buf.signature_help()
    ]], false)
  end
end

lspconfig = require('lspconfig')
lspconfig.diagnosticls.setup{ on_attach = on_attach }
lspconfig.html.setup{ on_attach = on_attach }
lspconfig.rnix.setup{ on_attach = on_attach }
lspconfig.tsserver.setup{ on_attach = on_attach }
lspconfig.bashls.setup{ on_attach = on_attach }

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

require('trouble').setup{
  mode = "lsp_document_diagnostics",
  use_lsp_diagnostic_signs = true
}
