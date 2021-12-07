----
-- OPTIONS
----

--
-- Shortcuts
--

local g = vim.g
local fn = vim.fn
local api = vim.api
local opt = vim.opt
local opt_local = vim.opt_local
local opt_global = vim.opt_global
local nvim_exec = vim.api.nvim_exec
local nvim_set_keymap = vim.api.nvim_set_keymap
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap

-- Space key as leader
g.mapleader = " "

--
-- General
--

opt.termguicolors = true
opt.ignorecase = true
opt.smartcase = true
opt.number = true
opt.relativenumber = true
opt.completeopt = "noinsert,menuone,noselect"
opt.mouse = "a"
opt.clipboard = "unnamedplus" -- Use system clipboard since we only use it for yanks (see key maps)
opt.scrolloff = 6
opt.spell = false -- Enabled for specific file types
opt.spelllang = {"en_us"}
opt.updatetime = 250
opt.ttimeoutlen = 50
opt.timeoutlen = 500 -- Recommended by which-key.nvim
opt.list = true
opt.listchars:append("space:⋅")
opt.listchars:append("eol:↴")

--
-- Explorer
--

g.netrw_liststyle = 4 -- Open in previous window
g.netrw_browse_split = 2 -- Split vertically
g.netrw_winsize = 25 -- In percent, ignored by `:Texplore` windows
g.netrw_altv = 1 -- Open file to the right
g.netrw_banner = 0 -- Hide banner

--
-- Formatting
--

opt.autoindent = true
opt.expandtab = true
opt.shiftwidth = 2
opt.softtabstop = 2
opt.tabstop = 2
opt.wrap = true -- Soft wrap
opt.wrapmargin = 100 -- Soft wrap column
opt.textwidth = 100 -- Hard wrap column when `formatoptions~=t` or `gq` is used
opt.formatoptions = "cjroql"

-- Quick reference (more at :h fo-table):
--
--   c -> comments auto-wrap at textwidth
--   j -> smart join comment lines
--   l -> don't wrap already long lines in insert mode
--   o -> auto-insert comment leader on `o` and `O`
--   q -> allow `gq` formatting
--   r -> auto-insert comment leader on <Enter>
--   t -> auto-wrap at textwidth
--
-- For hard wrap: tcjroql
-- For hard wrap comments only: cjroql

--
-- Color scheme
--

-- require("onenord").setup({
--   borders = true,
--   italics = {
--     comments = true,
--     strings = false,
--     keywords = true,
--     functions = false,
--     variables = false,
--   },
--   disable = {
--     background = true,
--     cursorline = true,
--     eob_lines = true,
--   },
--   custom_highlights = {}
-- })

require("catppuccin").setup({
  transparent_background = true,
  term_colors = true,
  styles = {
    comments = "italic",
    functions = "italic",
    keywords = "italic",
    strings = "NONE",
    variables = "NONE",
  },
  integrations = {
    treesitter = true,
    native_lsp = {
      enabled = true,
      virtual_text = {
        errors = "italic",
        hints = "italic",
        warnings = "italic",
        information = "italic",
      },
      underlines = {
        errors = "underline",
        hints = "underline",
        warnings = "underline",
        information = "underline",
      },
    },
    lsp_trouble = true,
    lsp_saga = false,
    gitgutter = false,
    gitsigns = true,
    telescope = false,
    nvimtree = {
      enabled = true,
      show_root = false,
    },
    which_key = true,
    indent_blankline = {
      enabled = false,
      colored_indent_levels = false,
    },
    dashboard = false,
    neogit = false,
    vim_sneak = false,
    fern = false,
    barbar = false,
    bufferline = false,
    markdown = true,
    lightspeed = true,
    ts_rainbow = false,
    hop = false,
  },
})

vim.cmd("colorscheme catppuccin")
