--
-- Plugins
--

-- Commenting

require("kommentary.config").use_extended_mappings()

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

-- Status line

require("feline").setup()

-- Completion

local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mappings = {
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable,
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<TAB>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "c" }),
    ["<S-TAB>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "c" })
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "vsnip" },
  }, {
    { name = "buffer" },
  })
})

cmp.setup.cmdline("/", {
  sources = {
    { name = "buffer" }
  }
})

cmp.setup.cmdline(":", {
  sources = cmp.config.sources({
    { name = "path" }
  }, {
    { name = "cmdline" }
  })
})

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

