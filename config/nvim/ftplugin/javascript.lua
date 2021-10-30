--
-- JavaScript
--

-- Maps

local opts = {
  nore = {noremap = true}
}

vim.api.nvim_set_keymap("i", ",clg", "console.log()<Left>", opts.nore)
vim.api.nvim_set_keymap("i", ",cld", "console.dir()<Left>", opts.nore)
vim.api.nvim_set_keymap("i", ",clo", "console.log('Object:', )<Left>", opts.nore)
