----
-- AUTOCOMMANDS
----

vim.api.nvim_exec([[
  "
  " Line diagnostics on hover
  "
  augroup line_diagnostics
    autocmd!
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
  augroup end

  "
  " Quick highlight on yank
  "
  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require("vim.highlight").on_yank({timeout = 100})
  augroup end
]], false)

