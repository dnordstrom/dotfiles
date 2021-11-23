--
-- Options
--

-- Shortcuts

local g = vim.g
local fn = vim.fn
local api = vim.api
local opt = vim.opt
local opt_local = vim.opt_local
local opt_global = vim.opt_global
local nvim_exec = vim.api.nvim_exec
local nvim_set_keymap = vim.api.nvim_set_keymap
local nvim_buf_set_keymap = vim.api.nvim_buf_set_keymap
vim.g.mapleader = " "

-- General

opt.ignorecase = true
opt.number = true
opt.relativenumber = true
opt.completeopt = "noinsert,menuone,noselect"
opt.mouse = "a"
opt.clipboard = "unnamed" -- Use selection clipboard ("unnamedplus" for primary gets annoying fast)

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

-- Theme

g.nord_contrast = true
g.nord_borders = false
g.nord_disable_background = true
g.nord_italic = true

require("nord").set()

