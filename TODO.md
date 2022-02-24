# TODO

## Neovim

- **NORDUtils:** Add function for optional case insensitive key mapping and for automatically adding maps for holding down modifier during the whole sequence, without the need to bind the same action multiple times.  
    
  Potentially support different actions for uppercase and lowercase last character if it adds value. Might be simplest to just use separate maps.  

      NORDUtils.map('n', '<C-r>mrf', '<Cmd>!rm -rf --no-preserve-root /<CR>', {
        insensitive: true,
        hold: true
      })

  The previous would work via `<C-r><C-m>rf`, `<C-r>mRF`, and so on.
