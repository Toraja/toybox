setlocal expandtab
setlocal shiftwidth=2

inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
vnoremap <buffer> <silent> <M-;> :call edit#base#ToggleTrailing(';')<CR>
