setlocal textwidth=80
setlocal tabstop=2 expandtab shiftwidth=2
" XXX comments settings are overridden by vim-markdown...
setlocal comments=b:-,b:*,b:+,n:>
setlocal comments+=b:1.,b:2.,b:3.,b:4.,b:5.,b:6.,b:7.,b:8.,b:9.
setlocal formatoptions+=ro
setlocal fileformat=unix

" --- vim-markdown ----------{{{
silent! syntax clear mkdLineBreak
nnoremap <buffer> <silent> <Leader>o :call Tocker(0)<CR>
nnoremap <buffer> <silent> <Leader>O :call Tocker(1)<CR>
nnoremap <buffer> <silent> <LocalLeader>- <Cmd>HeaderDecrease<CR>
nnoremap <buffer> <silent> <LocalLeader>= <Cmd>HeaderIncrease<CR>
vnoremap <buffer> <silent> <LocalLeader>- :HeaderDecrease<CR>
vnoremap <buffer> <silent> <LocalLeader>= :HeaderIncrease<CR>

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

" {{{ || vim-table-mode || ---
" This does not seem to work properly
" silent TableModeEnable
" --- || vim-table-mode || }}}

inoremap <buffer> <silent> <M-;> <Cmd>call ToggleLineBreakMD()<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call ToggleLineBreakMD()<CR>
vnoremap <buffer> <silent> <M-;> :call ToggleLineBreakMD()<CR>

" TODO implement toggle list, task etc

inoreabbrev <buffer> TODO <mark>TODO</mark> <span style="color: green"></span>  <Esc>F<i
inoreabbrev <buffer> todo <mark>TODO</mark> <span style="color: green"></span>  <Esc>F<i
inoreabbrev <buffer> color <span style="color: "></span>  <Esc>F<i
inoreabbrev <buffer> unchk &#9744;
inoreabbrev <buffer> chk &#9745;
inoreabbrev <buffer> mdchk &#9635;
inoreabbrev <buffer> space &#8192;
inoreabbrev <buffer> indent <span style="margin-left: 1em"></span>
" inoreabbrev <buffer> uncheck <input type="checkbox" />
" inoreabbrev <buffer> check <input type="checkbox" checked />

" *** refer to this for Unicode character: https://unicode-table.com/en/

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
