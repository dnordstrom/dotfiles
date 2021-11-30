----
-- PLUGIN SETTINGS
----

-- cokeline.nvim

local get_hex = require("cokeline.utils").get_hex

require("cokeline").setup({
  cycle_prev_next_mappings = true,
  buffers = {
    new_buffers_position = "last",
  },
  default_hl = {
    focused = {
      fg = get_hex("ColorColumn", "bg"),
      bg = get_hex('Normal', "fg"),
    },
    unfocused = {
      fg = get_hex("Normal", "fg"),
      bg = get_hex("Normal", "bg"),
    },
  },
  components = {
    {
      text = function(buffer) return " " .. buffer.devicon.icon end,
      hl = {
        fg = function(buffer) return buffer.devicon.color end,
      },
    },
    {
      text = function(buffer) return buffer.unique_prefix end,
      hl = {
        fg = get_hex("Comment", "fg"),
        style = "italic",
      },
    },
    {
      text = function(buffer) return buffer.filename .. ' ' end,
    },
    {
      text = "",
      delete_buffer_on_left_click = true,
    },
    {
      text = ' ',
    }
  },
})

-- bufferline.nvim

-- require('bufferline').setup({
--   options = {
--     numbers = "none" | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
--     --- @deprecated, please specify numbers as a function to customize the styling
--     number_style = "superscript" | "subscript" | "" | { "none", "subscript" }, -- buffer_id at index 1, ordinal at index 2
--     close_command = "bdelete! %d",       -- can be a string | function, see "Mouse actions"
--     right_mouse_command = "bdelete! %d", -- can be a string | function, see "Mouse actions"
--     left_mouse_command = "buffer %d",    -- can be a string | function, see "Mouse actions"
--     middle_mouse_command = nil,          -- can be a string | function, see "Mouse actions"
--     -- NOTE: this plugin is designed with this icon in mind,
--     -- and so changing this is NOT recommended, this is intended
--     -- as an escape hatch for people who cannot bear it for whatever reason
--     indicator_icon = '▎',
--     buffer_close_icon = '',
--     modified_icon = '●',
--     close_icon = '',
--     left_trunc_marker = '',
--     right_trunc_marker = '',
--     --- name_formatter can be used to change the buffer's label in the bufferline.
--     --- Please note some names can/will break the
--     --- bufferline so use this at your discretion knowing that it has
--     --- some limitations that will *NOT* be fixed.
--     name_formatter = function(buf)  -- buf contains a "name", "path" and "bufnr"
--       -- remove extension from markdown files for example
--       if buf.name:match('%.md') then
--         return vim.fn.fnamemodify(buf.name, ':t:r')
--       end
--     end,
--     max_name_length = 18,
--     max_prefix_length = 15, -- prefix used when a buffer is de-duplicated
--     tab_size = 18,
--     diagnostics = false | "nvim_lsp" | "coc",
--     diagnostics_update_in_insert = false,
--     diagnostics_indicator = function(count, level, diagnostics_dict, context)
--       return "("..count..")"
--     end,
--     -- NOTE: this will be called a lot so don't do any heavy processing here
--     custom_filter = function(buf_number)
--       -- filter out filetypes you don't want to see
--       if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
--         return true
--       end
--       -- filter out by buffer name
--       if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
--         return true
--       end
--       -- filter out based on arbitrary rules
--       -- e.g. filter out vim wiki buffer from tabline in your work repo
--       if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
--         return true
--       end
--     end,
--     offsets = {{filetype = "NvimTree", text = "File Explorer" | function , text_align = "left" | "center" | "right"}},
--     show_buffer_icons = true | false, -- disable filetype icons for buffers
--     show_buffer_close_icons = true | false,
--     show_close_icon = true | false,
--     show_tab_indicators = true | false,
--     persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
--     -- can also be a table containing 2 custom separators
--     -- [focused and unfocused]. eg: { '|', '|' }
--     separator_style = "slant" | "thick" | "thin" | { 'any', 'any' },
--     enforce_regular_tabs = false | true,
--     always_show_bufferline = true | false,
--     sort_by = 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
--       -- add custom logic
--       return buffer_a.modified > buffer_b.modified
--     end
--   }
-- })

-- nvim-tree

require'nvim-tree'.setup({})

-- surround.nvim

require("surround").setup({
  mappings_style = "sandwich",
  map_insert_mode = false, -- pears.nvim handles this
  quotes = {"'", '"', "`"},
  brackets = {"(", "{", "[", "<"},
  pairs = {
    nestable = {
      {"(", ")"},
      {"[", "]"},
      {"{", "}"},
      {"<", ">"}
    },
    linear = {
      {"'", "'"},
      {'"', '"'},
      {"`", "`"}
    }
  },
  prefix = "<C-s>"
})

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

require("which-key").setup({
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = false, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- The presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = true, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- Add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset/operators plugin above
  operators = {
    gc = "Comments",
    gs = "Web search"
  },
  key_labels = {
    -- Override the label used to display some keys. It doesn't effect WK in any other way.
    -- For example:
    ["<space>"] = "Space",
    ["<cr>"] = "Enter",
    ["<tab>"] = "Tab",
    ["<esc>"] = "Escape",
    ["<bs>"] = "Backspace",
  },
  icons = {
    breadcrumb = "»", -- Symbol used in the command line area that shows your active key combo
    separator = "➜", -- Symbol used between a key and it's label
    group = "+", -- Symbol prepended to a group
  },
  popup_mappings = {
    scroll_down = '<C-d>', -- Binding to scroll down inside the popup
    scroll_up = '<C-u>', -- Binding to scroll up inside the popup
  },
  window = {
    border = "double", -- None, single, double, shadow
    position = "bottom", -- Bottom, top
    margin = { 4, 4, 2, 4 }, -- Extra window margin [top, right, bottom, left]
    padding = { 1, 1, 1, 1 }, -- Extra window padding [top, right, bottom, left]
    winblend = 10 -- Value between 1 and 100
  },
  layout = {
    height = { min = 4, max = 25 }, -- Min and max height of the columns
    width = { min = 20, max = 50 }, -- Min and max width of the columns
    spacing = 3, -- Spacing between columns
    align = "left", -- Align columns left, center or right
  },
  ignore_missing = false, -- Enable this to hide mappings for which you didn't specify a label
  hidden = { "<Silent>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ "}, -- Hide mapping boilerplate
  show_help = true, -- show help message on the command line when the popup is visible
  triggers = "auto", -- automatically setup triggers
  triggers_blacklist = {
    i = { "j", "k" },
    v = { "j", "k" },
  },
})

-- Comment labels

require("todo-comments").setup({})

-- Trouble

require("trouble").setup({
  mode = "lsp_document_diagnostics",
  use_lsp_diagnostic_signs = true,
})

-- feline

require("feline").setup({preset = "noicon"})

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

-- nvim-autopairs

local npairs = require("nvim-autopairs")

npairs.setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},-- it will not add a pair on that treesitter node
    javascript = {'template_string'},
    java = false,-- don't check treesitter on java
  }
})

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done({map_char = { tex = ""}}))

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

require('gitsigns').setup({
  signs = {
    add = {hl = 'GitSignsAdd', text = '│', numhl='GitSignsAddNr', linehl='GitSignsAddLn'},
    change = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
    delete = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    topdelete = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
  },
  signcolumn = false,
  numhl = false,
  linehl = false,
  word_diff = false,
  keymaps = {
    noremap = true,
  },
  watch_gitdir = {
    interval = 1000,
    follow_files = true
  },
  attach_to_untracked = true,
  current_line_blame = false,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align',
    delay = 500,
    ignore_whitespace = true,
  },
  current_line_blame_formatter_opts = {
    relative_time = false
  },
  sign_priority = 6,
  update_debounce = 500,
  status_formatter = nil,
  max_file_length = 40000,
  preview_config = {
    border = 'double',
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 2
  },
  yadm = {
    enable = false
  },
})

