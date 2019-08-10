" set iskeyword=@,48-57,_,192-255,# " this disables syntax highlight for comment 
" set equalprg=fish_indent " this does not work when running = command on single line
set expandtab " fish_indent prefer space

if has("autocmd")
	augroup my_fish
		autocmd!
		autocmd BufWritePre *.fish call Preserve('call Format()', 0, 0)
	augroup END
endif

function! Format()
	if !executable('fish_indent')
		return
	endif
	silent exec "%!fish_indent"
endf
