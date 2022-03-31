setlocal textwidth=0            " overwrite the system vim.vim setting
setlocal foldmethod=marker      " enable folding by marker {{{}}}
setlocal expandtab tabstop=2 shiftwidth=2
setlocal omnifunc=syntaxcomplete#Complete

" if
inoreabbrev <buffer> if if <CR>endif<Up><End>
inoreabbrev <buffer> ife if <CR>else<CR>endif<Up><Up><End>
inoreabbrev <buffer> ifee if <CR>elseif <CR>else<CR>endif<Up><Up><Up><End>
inoreabbrev <buffer> ifh if has('')<CR>endif<Esc><Up>f'a
inoreabbrev <buffer> ifx if exists('')<CR>endif<Esc><Up>f'a
" for
inoreabbrev <buffer> for for i in <CR>endfor<Up><End>
" while
inoreabbrev <buffer> wh while <CR>endwhile<Up>
" function
inoreabbrev <buffer> fu function! ()<CR>endfunction<Up><Left>
" misc
inoreabbrev <buffer> ehl echohl <CR>echohl NONE<Up>
inoreabbrev <buffer> fd " {{{ <Bar><Bar>  <Bar><Bar> ---<CR>--- <Bar><Bar>  <Bar><Bar> }}}<Esc>2F<Space><C-v><Up>I
