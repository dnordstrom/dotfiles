----
-- LANGUAGE SERVERS AND TOOLS
----

local lspconfig = require("lspconfig")
local null_ls = require("null-ls")

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

-- null-ls

null_ls.config({
  sources = {
    null_ls.builtins.diagnostics.eslint_d,
    null_ls.builtins.code_actions.eslint_d,
    null_ls.builtins.formatting.eslint_d
  }
})

lspconfig["null-ls"].setup({})

-- tsserver

lspconfig.tsserver.setup({
  init_options = require("nvim-lsp-ts-utils").init_options,

  on_attach = function(client, bufnr)
    local ts_utils = require("nvim-lsp-ts-utils")

    -- Disable tsserver formatting in favor of null-ls
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false

    ts_utils.setup({
      -- Linting
      eslint_bin = "eslint_d",
      eslint_enable_diagnostics = true,
      eslint_enable_code_actions = true,
      enable_formatting = true,
      formatter = "eslint_d",

      -- Filter diagnostics
      filter_out_diagnostics_by_severity = {},
      filter_out_diagnostics_by_code = {
        6133, -- Declared but value never read
        7016, -- Could not find declaration file
      }
    })

    -- Required to fix code action ranges and filter diagnostics
    ts_utils.setup_client(client)

    -- Format on save
    vim.cmd("autocmd BufWritePre <Buffer> lua vim.lsp.buf.formatting()")
  end,
})

-- Autoloaded

local on_attach = function(client, bufid) end
local capabilities = require("cmp_nvim_lsp").update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true
local servers = {"html", "cssls", "jsonls", "bashls", "gopls", "yamlls", "vimls"}

for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup({
    on_attach = on_attach,
    capabilities = capabilities
  })
end

-- Diagnostics settings
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = true,
  }
)

-- Diagnostics signs
--
-- NerdFonts reference:
--    na-fa-angle_left
--    na-fa-angle_double_left
--    nf-fa-arrow_circle_right
--    nf-fa-arrow_right
--    nf-fa-chevron_circle_right
--    nf-fa-chevron_right
--    nf-fa-circle
--    nf-fa-circle_o
--    nf-fa-info
--    nf-fa-info_circle
--    nf-fa-times_circle
--    nf-fa-asterisk
--   ﴫ nf-mdi-ladybug
--    nf-mdi-checkbox_blank
--    nf-mdi-checkbox_blank_outline
--    nf-mdi-checkbox_marked
--   ﱣ nf-mdi-circle
--   ﱤ nf-mdi-circle_outline
--   﫟nf-mdi-check_circle
--   﫠nf-mdi-check_circle_outline
--    nf-mdi-close_circle
--    nf-mdi-close_circle_outline
--   卑nf-mdi-triangle
--   喝nf-mdi-triangle_outline
--    nf-mdi-close
--    nf-mdi-alert
--    nf-mdi-alert_box
--    nf-mdi-alert_circle
--    nf-mdi-close_circle
--    nf-mdi-arrow_right
--    nf-mdi-arrow_right_thick
--   ﰲ nf-mdi-arrow_right_bold
--   ﯀ nf-mdi-arrow_right_box
--   ﰳ nf-mdi-arrow_right_bold_box
--    nf-mdi-arrow_right_bold_circle
--    nf-mdi-bookmark
--    nf-mdi-bookmark_outline
--    nf-mdi-bug
--   ﴫ nf-mdi-ladybug
--   ﰸ nf-mdi-cancel
--    nf-mdi-chevron_double_right
--    nf-mdi-chevron_right
--    nf-mdi-heart
--    nf-mdi-help
--    nf-mdi-label
--    nf-mdi-label_outline
--    nf-mdi-lightbulb
--    nf-mdi-lightbulb_outline
--    nf-mdi-multiplication
--    nf-mdi-multiplication_box
--   留nf-mdi-star
--    nf-oct-alert
--    nf-oct-bug
--    nf-oct-chevron_right
--    nf-oct-flame
--   ♥ nf-oct-heart
--    nf-oct-star
--    nf-oct-smiley
--    nf-oct-x
--    nf-oct-tag
--    nf-oct-primitive_dot
--    nf-oct-primitive_square
--    nf-oct-dash
--    nf-oct-issue_opened
--    nf-oct-light_bulb
--    nf-oct-circle_slash
--    nf-oct-check
--    nf-oct-bookmark
--    nf-oct-arrow_right
--    nf-oct-bell
--   
--   For remixicon etc, use https://mathew-kurian.github.io/CharacterMap
local signs = {
  Error = " ",
  Warning = " ",
  Hint = " ",
  Information = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticsSign" .. type

  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = hl,
  })
end

