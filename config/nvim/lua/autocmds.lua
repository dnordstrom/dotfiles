--
-- Autocommands
--

vim.api.nvim_exec([[
  augroup line_diagnostics
    autocmd!
    autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()
  augroup end

  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require("vim.highlight").on_yank({timeout = 100})
  augroup end
]], false)

