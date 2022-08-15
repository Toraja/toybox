setlocal formatoptions+=ro
setlocal fileformat=unix

" --- vim-markdown ----------{{{
silent! syntax clear mkdLineBreak
nnoremap <buffer> <silent> <Leader>o :call Tocker(0)<CR>
nnoremap <buffer> <silent> <Leader>O :call Tocker(1)<CR>
nnoremap <buffer> <silent> <LocalLeader>- <Cmd>HeaderDecrease<CR>
nnoremap <buffer> <silent> <LocalLeader>= <Cmd>HeaderIncrease<CR>
xnoremap <buffer> <silent> <LocalLeader>- :HeaderDecrease<CR>
xnoremap <buffer> <silent> <LocalLeader>= :HeaderIncrease<CR>

function! Tocker(focus)
	if get(b:, 'toc_win_id')
		let l:toc_winnr = win_id2win(b:toc_win_id)
		if l:toc_winnr
			if a:focus
				execute l:toc_winnr . 'wincmd w'
				return
			endif
			silent! execute l:toc_winnr.'close'
			return
		endif
	endif

	Toc
	let l:toc_win_id = bufwinid('')
	nnoremap <buffer> <silent> <Leader>o :close<CR>
	nnoremap <buffer> <silent> <Leader>O <Nop>
	nnoremap <buffer> <silent> q :close<CR>
	wincmd p
	let b:toc_win_id = l:toc_win_id " for the buffer toc is for
	if a:focus
		execute win_id2win(b:toc_win_id).'wincmd w'
	endif
endfunction
" --- end of vim-markdown ---}}}

inoremap <buffer> <silent> <M-;> <Cmd>call ToggleLineBreakMD()<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call ToggleLineBreakMD()<CR>
xnoremap <buffer> <silent> <M-;> :call ToggleLineBreakMD()<CR>

inoreabbrev <buffer> TODO <mark>TODO</mark> <span style="color: green"></span>  <Esc>F<i
inoreabbrev <buffer> todo <mark>TODO</mark> <span style="color: green"></span>  <Esc>F<i

" Add or remove linebreak for selected lines.
" Whether add or remove is determined by whether the first line has linebreak or not.
" The following lines are treated only if necessary.
" i.e. if 3 lines are selected and the first and the third line does not have linebreak
" while the second line does, the second line remains no changed.
function! ToggleLineBreakMD() range
	let l:first_line = getline(a:firstline)
	let l:first_line_has_linebreak = match(l:first_line, '\s\s\+$') >= 0
	let l:replacement = l:first_line_has_linebreak ? '' : '  '

	for l:ln in range(a:firstline, a:lastline)
		call setline(l:ln, substitute(getline(l:ln), '\s*$', l:replacement, ''))
	endfor
endfunction
