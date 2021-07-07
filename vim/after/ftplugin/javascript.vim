setlocal expandtab
setlocal shiftwidth=2

inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#Append(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#Append(';')<CR>
vnoremap <buffer> <silent> <M-;> :call edit#base#Append(';')<CR>
