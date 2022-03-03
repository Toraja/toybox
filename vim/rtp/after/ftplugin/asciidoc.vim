setlocal tabstop=2 expandtab shiftwidth=2

inoremap <buffer> <silent> <M-;> <Cmd>call ToggleLinebreak()<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call ToggleLinebreak()<CR>

function! ToggleLinebreak()
	let l:linebreak = ' +'
	let l:line = getline('.')
	let l:line_has_linebreak = match(l:line, l:linebreak . '$') >= 0
	let l:target = l:line_has_linebreak ? l:linebreak : ''
	let l:replacement = l:line_has_linebreak ? '' : l:linebreak
	call setline('.', substitute(l:line, l:target . '$', l:replacement, ''))
endfunction
