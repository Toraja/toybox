" {{{ || vim-test || ---
if exists('g:plugs["vim-test"]')
  if executable('richgo')
    let test#go#runner = 'richgo'
  endif
endif
" --- || vim-test || }}}
