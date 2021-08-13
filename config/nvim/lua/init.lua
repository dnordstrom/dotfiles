--
-- Shortcuts
--

local g = vim.g
local o = vim.opt

--
-- Settings
--

g.mapleader = ','

o.backup = false
o.writebackup = false
o.ignorecase = true
o.number = true
o.relativenumber = true
o.swapfile = false

--
-- Formatting
--

o.autoindent = true
o.expandtab = true
o.shiftwidth = 2
o.softtabstop = 2
o.tabstop = 2

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
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };

  source = {
    path = true;
    buffer = true;
    calc = true;
    nvim_lsp = true;
    nvim_lua = true;
    vsnip = true;
    ultisnips = true;
    luasnip = true;
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
    return termcodes "<C-n>"
  elseif check_back_space() then
    return termcodes "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end

_G.shift_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return termcodes "<C-p>"
  else
    return termcodes "<S-Tab>"
  end
end

--
-- Global Key Maps
--

local remap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

---- Clear search highlights
remap('n', '<Leader><Space>', ':set hlsearch!<CR>', opts)

---- Go to buffer
remap('n', 'gb', ':ls<CR>:b<Space>', opts)

---- Go to definition
remap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
remap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)

---- Autocomplete
remap('i', '<S-Space>', 'compe#complete()', opts)
remap('i', '<S-C-Space>', 'compe#close()', opts)
remap("i", "<Tab>", "v:lua.tab_complete()", opts)
remap("s", "<Tab>", "v:lua.tab_complete()", opts)
remap("i", "<S-Tab>", "v:lua.shift_tab_complete()", opts)
remap("s", "<S-Tab>", "v:lua.shift_tab_complete()", opts)

--
-- Language Servers
--

lspconfig = require('lspconfig')
lspconfig.denols.setup { on_attach = on_attach }
lspconfig.html.setup { on_attach = on_attach }
lspconfig.rnix.setup { on_attach = on_attach }
lspconfig.tsserver.setup { on_attach = on_attach }
lspconfig.bashls.setup { on_attach = on_attach }
