setlocal textwidth=0			" overwrite the system vim.vim setting
setlocal foldmethod=marker		" enable folding by marker {{{}}}
" setlocal iskeyword+=:
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

inoremap <buffer> <expr> < EnterKeycodes()
" TODO refactor
function! EnterKeycodes()
	while 1
		echohl Statement
			echo "-- <Keycode> -> <CR>/<C-M>,b,C,D,e,E,l,L,N,s,S,T,U,\\,<,?(help)"
		echohl NONE
		let l:char = nr2char(getchar())
		if l:char ==# "b"
			let l:cmd = "<buffer>"
		elseif l:char ==# "C"
			let l:cmd = "<C->\<Left>"
		elseif l:char ==# "D"
			let l:cmd = "<Down>"
		elseif l:char ==# "e"
			let l:cmd = "<expr>"
		elseif l:char ==# "E"
			let l:cmd = "<Esc>"
		elseif l:char ==# "l"
			let l:cmd = "<Leader>"
		elseif l:char ==# "L"
			let l:cmd = "<Left>"
		elseif l:char ==# "N"
			let l:cmd = "<Nop>"
		elseif l:char ==# "R"
			let l:cmd = "<Right>"
		elseif l:char ==# "s"
			let l:cmd = "<silent>"
		elseif l:char ==# "S"
			let l:cmd = "<Space>"
		elseif l:char ==# "T"
			let l:cmd = "<Tab>"
		elseif l:char ==# "U"
			let l:cmd = "<Up>"
		elseif l:char ==# "\\"
			let l:cmd = "<lt>"
		elseif l:char ==# "\<CR>"
			let l:cmd = "<CR>"
		elseif l:char ==# "<"
			let l:cmd = "<"
		elseif l:char ==# ">"
			let l:cmd = "<>"
		elseif l:char ==# "?"
			let l:helptext = "  b: buffer\<NL>"
			let l:helptext .= "  D: Down\<NL>"
			let l:helptext .= "  e: expr\<NL>"
			let l:helptext .= "  E: Esc\<NL>"
			let l:helptext .= "  l: Leader\<NL>"
			let l:helptext .= "  L: Left\<NL>"
			let l:helptext .= "  N: Nop\<NL>"
			let l:helptext .= "  R: Right\<NL>"
			let l:helptext .= "  s: silent\<NL>"
			let l:helptext .= "  S: Space\<NL>"
			let l:helptext .= "  T: Tab\<NL>"
			let l:helptext .= "  U: Up\<NL>"
			let l:helptext .= "  \\: lt\<NL>"
			let l:helptext .= "  <CR>: CR\<NL>"
			let l:helptext .= "  <: quit"
			let l:helptext .= "  ?: display this help"
			echo l:helptext
			redraw
			continue
		else
			let l:cmd = '<' . l:char . ">\<Left>"
		endif
		break
	endwhile

	return l:cmd
endfunction
