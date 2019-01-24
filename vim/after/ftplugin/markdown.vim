setlocal textwidth=100
setlocal tabstop=2 expandtab shiftwidth=2
" setlocal comments-=fb:-,fb:*	" Can't remove them somehow
setlocal comments=b:-,b:*,b:+,n:>
setlocal comments+=b:1.,b:2.,b:3.,b:4.,b:5.,b:6.,b:7.,b:8.,b:9.
setlocal formatoptions+=ro
setlocal fileformat=unix

" --- vim-markdown ----------{{{
silent! syntax clear mkdLineBreak
nmap <M-N> <Plug>Markdown_MoveToNextHeader
nmap <M-P> <Plug>Markdown_MoveToPreviousHeader
" nnoremap [FTLeader]<C-v> :let t:winnum = winnr()<CR>:Tocv<CR>:silent execute t:winnum . 'wincmd w'<CR>
nnoremap <LocalLeader><C-v> :let t:winnum = winnr()<CR>:Tocv<CR>:silent execute t:winnum . 'wincmd w'<CR>
nnoremap <LocalLeader><C-s> :let t:winnum = winnr()<CR>:Toch<CR>:silent execute t:winnum . 'wincmd w'<CR>
nnoremap <LocalLeader>- :HeaderDecrease<CR>
nnoremap <LocalLeader>= :HeaderIncrease<CR>
" nnoremap [FTLeader]<C-s> :let t:winnum = winnr()<CR>:Toch<CR>:silent execute t:winnum . 'wincmd w'<CR>
" nnoremap [FTLeader]- :HeaderDecrease<CR>
" nnoremap [FTLeader]= :HeaderIncrease<CR>
" --- end of vim-markdown ---}}}

" {{{ || vim-table-mode || ---
" This does not seem to work properly
" silent TableModeEnable
" --- || vim-markdown || }}}

" TODO add styling mapping using ys (vim-surround)
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
