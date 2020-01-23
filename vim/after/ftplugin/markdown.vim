setlocal textwidth=100
setlocal tabstop=2 expandtab shiftwidth=2
" setlocal comments-=fb:-,fb:*	" Can't remove them somehow
setlocal comments=b:-,b:*,b:+,n:>
setlocal comments+=b:1.,b:2.,b:3.,b:4.,b:5.,b:6.,b:7.,b:8.,b:9.
setlocal formatoptions+=ro
setlocal fileformat=unix

" --- vim-markdown ----------{{{
silent! syntax clear mkdLineBreak
nnoremap <buffer> <silent> <Leader>o :call Tocker(0)<CR>
nnoremap <buffer> <silent> <Leader>O :call Tocker(1)<CR>
nnoremap <buffer> <silent> <LocalLeader>- :HeaderDecrease<CR>
nnoremap <buffer> <silent> <LocalLeader>= :HeaderIncrease<CR>

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

	let t:toc_org_winnr = winnr()
	Toc
	let l:toc_win_id = bufwinid('')
	let b:toc_win_id = l:toc_win_id " for toc buffer
	execute t:toc_org_winnr . 'wincmd w'
	let b:toc_win_id = l:toc_win_id " for the buffer toc is for
	if a:focus
		execute win_id2win(b:toc_win_id).'wincmd w'
	endif
endfunction
" --- end of vim-markdown ---}}}

" {{{ || vim-table-mode || ---
" This does not seem to work properly
" silent TableModeEnable
" --- || vim-markdown || }}}

inoremap <buffer> _ __<Left>
inoremap <buffer> * ****<Left><Left>
inoremap <buffer> *<Space> *<Space>
inoremap <buffer> *<S-Space> *<Space>
inoremap <buffer> ` ``<Left>
inoremap <buffer> ``` ```<CR>```<Up>
inoremap <buffer> ~ ~~~~<Left><Left>
inoremap <buffer> <silent> <expr> <M-;> IToggleLinebreak()
nnoremap <buffer> <silent> <expr> <M-;> ToggleLinebreak()
vnoremap <buffer> <silent> <M-;> <Esc>:call VToggleLinebreak()<CR>

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

function! ToggleLinebreak()
	let l:regex_md_linebreak = '\s\s\+$'
	let l:zero_or_one_trailing_space = '\s\?$'
	let l:base_cmd = ":substitute/%s/%s/\<CR>:nohlsearch\<CR>"
	let l:cmd_append_linebreak = printf(l:base_cmd, l:zero_or_one_trailing_space, '  ')
	let l:cmd_delete_linebreak = printf(l:base_cmd, l:regex_md_linebreak, '')
	let l:line = getline('.')
	let l:with_linebreak = match(l:line, l:regex_md_linebreak) >= 0
	let l:cmd = l:with_linebreak ? l:cmd_delete_linebreak : l:cmd_append_linebreak
	" add mark and come back to it so that cursor position stays same
	let l:cmd = "m'".l:cmd."`'"
	return l:cmd
endfunction

function! IToggleLinebreak()
	return "\<Esc>".ToggleLinebreak().'a'
endfunction

" Add or remove linebreak for selected lines.
" Whether add or remove is determined by whether the first line has linebreak or not.
" The following lines are treated only if necessary.
" i.e. if 3 lines are selected and the first and the third line does not have linebreak
" while the second line does, the second line remains no changed.
function! VToggleLinebreak()
	let l:regex_md_linebreak = '\s\s\+$'
	let l:zero_or_one_trailing_space = '\s\?$'
	let l:start_line_num = line("'<")
	let l:end_line_num  = line("'>")
	let l:is_start_line_with_linebreak = match(getline(l:start_line_num), l:regex_md_linebreak) >= 0
	let l:base_cmd = "substitute/%s/%s/"
	let l:cmd_append_linebreak = printf(l:base_cmd, l:zero_or_one_trailing_space, '  ')
	let l:cmd_delete_linebreak = printf(l:base_cmd, l:regex_md_linebreak, '')
	for l:linenum in range(l:start_line_num, l:end_line_num)
		let l:current_line = getline(l:linenum)
		let l:is_current_line_with_linebreak = match(getline(l:linenum), l:regex_md_linebreak) >= 0
		" command should be executed only for the lines that have same linebreak state as the first line
		if l:is_current_line_with_linebreak == l:is_start_line_with_linebreak
			if l:is_start_line_with_linebreak
				let l:cmd = l:cmd_delete_linebreak
			else
				let l:cmd = l:cmd_append_linebreak
			endif
		else
			continue
		endif
		" run substitute command for the line
		let l:cmd = l:linenum.",".l:linenum.l:cmd
		execute l:cmd
	endfor
	" clear search highlight marked by substitute command
	nohlsearch
endfunction
