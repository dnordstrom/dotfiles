----
-- MARKDOWN
----

--
-- Shortcuts
--

local opt = vim.opt
local nvim_set_keymap = vim.api.nvim_set_keymap

--
-- Options
--

opt.foldenable = false
opt.spell = true

--
-- Key maps
--

nvim_set_keymap("n", "<Leader>p", "<Cmd>Glow<CR>", { noremap = true })
