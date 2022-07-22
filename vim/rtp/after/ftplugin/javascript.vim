setlocal expandtab
setlocal shiftwidth=2

inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
xnoremap <buffer> <silent> <M-;> :call edit#base#ToggleTrailing(';')<CR>
