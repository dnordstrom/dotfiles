----
-- AUTOCOMMANDS
----

local autocommands = [[
  "
  " COMMANDS
  "

  augroup resize
    autocmd!

    " Floating window resize issue fix
    autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"
  augroup end

  augroup utils
    autocmd!

    " Floating window resize issue fix
    autocmd VimEnter * :silent exec "!kill -s SIGWINCH $PPID"

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
  " HOVER DIAGNOSTICS
  "

  augroup line_diagnostics
    autocmd!
    autocmd CursorHold,CursorHoldI * silent! lua vim.diagnostic.open_float()
  augroup end

  "
  " YANK HIGHLIGHT
  "

  augroup highlight_yank
    autocmd!
    autocmd TextYankPost * silent! lua require("vim.highlight").on_yank({timeout = 100})
  augroup end
]]

vim.api.nvim_exec(autocommands, false)
