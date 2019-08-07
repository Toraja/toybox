set iskeyword=@,48-57,_,192-255,#

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
