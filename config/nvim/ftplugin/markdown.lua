local g = vim.g
local o = vim.opt
local api = vim.api
local nvim_exec = api.nvim_exec
local nvim_set_keymap = api.nvim_set_keymap
local nvim_buf_set_keymap = api.nvim_buf_set_keymap

-- Markdown
g.vim_markdown_autowrite = 1
g.vim_markdown_conceal = 1
g.vim_markdown_conceal_code_blocks = 0
g.vim_markdown_fenced_languages = { "js=javascript" }
g.vim_markdown_folding_disabled = 0
g.vim_markdown_folding_level = 3
g.vim_markdown_follow_anchor = 1
g.vim_markdown_frontmatter = 1
g.vim_markdown_no_extensions_in_markdown = 0
