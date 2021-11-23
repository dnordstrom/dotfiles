--
-- Markdown
--

-- Options
vim.opt.foldenable = false

-- vim-markdown
vim.g.vim_markdown_autowrite = 1
vim.g.vim_markdown_conceal = 1
vim.g.vim_markdown_conceal_code_blocks = 0
vim.g.vim_markdown_fenced_languages = { "js=javascript" }
vim.g.vim_markdown_folding_disabled = 1
vim.g.vim_markdown_folding_level = 4
vim.g.vim_markdown_follow_anchor = 1
vim.g.vim_markdown_frontmatter = 1
vim.g.vim_markdown_no_extensions_in_markdown = 0

-- Maps
vim.api.nvim_set_keymap("n", "<Space>p", "<Cmd>Glow<CR>", {noremap = true})
