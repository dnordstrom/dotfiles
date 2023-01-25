----
-- MARKDOWN
--
-- Here we have Glow for previewing while Headlines.nvim gives us background highlights for code
-- blocks, quote blocks, headlines, and horizontal lines, and LuaSnip provides crazy flexible
-- snippet capabilities. Friendly Snippets is a great start.
--
-- Viewing/reading is also done in Vifm, mdcat, and Glow---solid tools.
--
-- See also:
--
--   - https://github.com/lukas-reineke/headlines.nvim
--   - https://github.com/L3MON4D3/LuaSnip
--   - https://github.com/rafamadriz/friendly-snippets
--   - https://www.bram.us/2022/01/07/glow-render-markdown-on-the-cli
--   - http://proselint.com
----

--
-- Shortcuts
--

local opt_local = vim.opt_local
local nvim_set_keymap = vim.api.nvim_set_keymap

--
-- Options
--

-- Hide folds
opt_local.foldenable = false

-- Hide line numbers
opt_local.number = false
opt_local.relativenumber = false

-- Enable spell checking
opt_local.spell = true

-- Adjust formatting. Reference:
--
--   t -> wrap text at textwidth.
--   c -> wrap comments at textwidth.
--   j -> join comments smartly, removing the extra prefix.
--   l -> prevent already long lines from wrap in insert mode (`gqq`)
--   o -> auto-insert comment leader on `o` and `O`
--   q -> allow `gq` formatting
--   r -> auto-insert comment leader on <Enter>
--
-- For hard wrap: tcjroql
-- For hard wrap comments only: cjroql

opt_local.formatoptions = "tcqlnj"

--
-- Key maps
--

nvim_set_keymap("n", "<Leader>p", "<Cmd>Glow<CR>", { noremap = true })
