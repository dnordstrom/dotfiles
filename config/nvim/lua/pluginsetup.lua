----
-- PLUGIN SETTINGS
----

-- LuaSnip

require("luasnip.loaders.from_vscode").lazy_load()

-- Comment.nvim

require('Comment').setup({
  pre_hook = function(ctx)
    -- Use nvim-ts-context-commentstring for commenting TSX/JSX markup
    if vim.bo.filetype == "typescriptreact" or vim.bo.filetype == "javascriptreact" then
      local U = require("Comment.utils")
      local type = ctx.ctype == U.ctype.line and "__default" or "__multiline"
      local location = nil

      if ctx.ctype == U.ctype.block then
        location = require("ts_context_commentstring.utils").get_cursor_location()
      elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
        location = require("ts_context_commentstring.utils").get_visual_start_location()
      end

      return require("ts_context_commentstring.internal").calculate_commentstring({
        key = type,
        location = location
      })
    end
  end
})

-- nvim-treesitter

require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  context_commentstring = {
    enable = true
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true,
      keymaps = {
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ap"] = "@parameter.outer",
        ["ip"] = "@parameter.inner",
        ["ak"] = "@comment.outer",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner"
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true,
      goto_next_start = {
        ["]m"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]M"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[m"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[M"] = "@function.outer",
        ["[]"] = "@class.outer",
      }
    }
  }
})

-- Show maps when typing

require("which-key").setup({})

-- Comment labels

require("todo-comments").setup({})

-- Autopairs

require("nvim-autopairs").setup({
  check_ts = true,
})

-- Trouble

require("trouble").setup({
  mode = "lsp_document_diagnostics",
  use_lsp_diagnostic_signs = true,
})

-- feline

require("feline").setup()

-- nvim-cmp, lspkind-nvim, luasnip, nvim-autopairs

-- Checks if cursor directly follows text
local has_word_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")
local cmp = require("cmp")
local mapping = cmp.mapping

-- Smart Tab navigates completion menu if visible, toggles completion if cursor follows text, and
-- otherwise falls back to normal tab insertion behavior
local function smart_tab(fallback)
  if cmp.visible() then
    cmp.select_next_item()
  elseif luasnip.expand_or_jumpable() then
    luasnip.expand_or_jump()
  elseif has_word_before() then
    cmp.complete()
  else
    fallback()
  end
end

-- Smart Shift-Tab navigates completion menu if visible, otherwise falls back to normal behavior
local function smart_shift_tab(fallback)
  if cmp.visible() then
    cmp.select_prev_item()
  elseif luasnip.jumpable(-1) then
    luasnip.jump(-1)
  else
    fallback()
  end
end

-- Defaults at https://github.com/hrsh7th/nvim-cmp/blob/main/lua/cmp/config/default.lua
cmp.setup({
  snippet = {
    -- Use luasnip for snippets
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    -- Completion close behavior depending on mode
    ["<C-e>"] = mapping({
      i = mapping.abort(), -- Close and restore line in insert mode
      c = mapping.close(), -- Close and discard line in command mode
    }),

    -- Only input mode is mapped unless otherwise specified, so these do not conflict with default
    -- command mode mappings
    ["<C-u>"] = mapping.scroll_docs(-4),
    ["<C-d>"] = mapping.scroll_docs(4),
    ["<C-n>"] = mapping.select_next_item(),
    ["<C-p>"] = mapping.select_prev_item(),

    -- Pressing enter without selection automatically inserts the top item in insert mode
    ["<CR>"] = mapping.confirm({select = true}),

    -- Use Tab for selection and Ctrl-Space for completion toggle in all modes
    ["<Tab>"] = mapping(smart_tab, {"i", "s"}),
    ["<S-Tab>"] = mapping(smart_shift_tab, {"i", "s"}),
    ["<C-Space>"] = mapping(mapping.complete(), {"i", "s"})
  },
  sources = {
    -- Input mode sources
    {name = "nvim_lsp"},
    {name = "buffer"},
    {name = "luasnip"},
    {name = "path"},
    {name = "rg"},
    {name = "calc"},
    {name = "spell"},
    {name = "look"},
    {name = "emoji"}
  },
  formatting = {
    -- Use lspkind-nvim to display source as icon instead of text
    format = lspkind.cmp_format({with_text = false, maxwidth = 50})
  },

  -- Experimental features default to false
  experimental = {
    ghost_text = true
  }
})

-- Search completion
cmp.setup.cmdline("/", {
  sources = {
    {name = "buffer"}
  }
})

-- Command completion
cmp.setup.cmdline(":", {
  sources = {
    {name = "path"},
    {name = "cmdline"}
  }
})

-- Insert ( on function completion
cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({ map_char = { tex = '' } }))

-- Renamer

local mappings_utils = require('renamer.mappings.utils')

require('renamer').setup {
  title = 'Rename',
  padding = {
      top = 0,
      left = 0,
      bottom = 0,
      right = 0,
  },
  border = true,
  border_chars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
  show_refs = true,
  with_qf_list = true,
  with_popup = true,
  mappings = {
    ['<c-i>'] = mappings_utils.set_cursor_to_start,
    ['<c-a>'] = mappings_utils.set_cursor_to_end,
    ['<c-e>'] = mappings_utils.set_cursor_to_word_end,
    ['<c-b>'] = mappings_utils.set_cursor_to_word_start,
    ['<c-c>'] = mappings_utils.clear_line,
    ['<c-u>'] = mappings_utils.undo,
    ['<c-r>'] = mappings_utils.redo,
  },
  handler = nil,
}

-- Colorizer

require("colorizer").setup()

-- Gitsigns

require('gitsigns').setup {
  signs = {
    add = {hl = 'GitSignsAdd', text = '│', numhl='GitSignsAddNr', linehl='GitSignsAddLn'},
    change = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  keymaps = {
    -- Default keymap options
    noremap = true,

    ['n ]c'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [c'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <leader>hs'] = '<cmd>lua require"gitsigns".stage_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hu'] = '<cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <leader>hr'] = '<cmd>lua require"gitsigns".reset_hunk({vim.fn.line("."), vim.fn.line("v")})<CR>',
    ['n <leader>hR'] = '<cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <leader>hp'] = '<cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <leader>hb'] = '<cmd>lua require"gitsigns".blame_line{full=true}<CR>',
    ['n <leader>hS'] = '<cmd>lua require"gitsigns".stage_buffer()<CR>',
    ['n <leader>hU'] = '<cmd>lua require"gitsigns".reset_buffer_index()<CR>',

    -- Text objects
    ['o ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-U>lua require"gitsigns.actions".select_hunk()<CR>'
  },
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000,
  preview_config = {
    -- Options passed to nvim_open_win
    border = 'single',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
  yadm = {
    enable = false
  },
}

