" setlocal iskeyword=@,48-57,_,192-255,# " this disables syntax highlight for comment 
" setlocal equalprg=fish_indent " this does not work when running = command on single line
setlocal expandtab " fish_indent prefer space

function! FishFormat(type, ...)
	if !executable('fish_indent')
		return
	endif

	if a:0  " Invoked from Visual mode
		let l:start = line("'<")
		let l:end = line("'>")
	else
		let l:start = line("'[")
		let l:end = line("']")
	endif

	silent exec printf("%s,%s!fish_indent", l:start, l:end)
endf

nnoremap = :call SetOperatorFunc('FishFormat')<CR>g@
vnoremap = :<C-u>call FishFormat(visualmode(), 1)<CR>
