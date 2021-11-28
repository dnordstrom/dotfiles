----
-- AUTOCOMMANDS
----

vim.api.nvim_exec([[
  "
  " Commands
  "
  augroup utils
    autocmd!
    " Utilities
    autocmd BufRead utils.lua command! NUpdateUtilsReturn lua NORDUtils.update_utils_return()
    autocmd VimEnter * command! -nargs=* NBrowserSearch lua NORDUtils.browsersearch(<q-args>)

    " Session management
    autocmd VimEnter * command! -nargs=* NSaveSession lua NORDUtils.save_session(<q-args>)
    autocmd VimEnter * command! -nargs=* NLoadSession lua NORDUtils.load_session(<q-args>)
    autocmd VimEnter * command! -nargs=* NS NSaveSession <args> " Alias
    autocmd VimEnter * command! -nargs=* NL NLoadSession <args> " Alias
    autocmd VimLeavePre * lua NORDUtils.save_session() " Autosave on exit, but only load explicitly
  augroup end

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

