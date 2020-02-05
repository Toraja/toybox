" redirect the output of external command into quickfix window
function! shell#base#ShellCmdToQF(cmd, append)
	if a:append
		laddexpr system(a:cmd)
	else
		lgetexpr system(a:cmd)
	endif

	let l:errornum = len(getloclist(0))
	if !l:errornum
		redraw
		echohl WarningMsg | echo 'No output from the command' | echohl NONE
		return
	endif
	execute 'lopen' . (l:errornum > 10 ? '' : l:errornum)
	set modifiable
	silent! %substitute/^|| //g
	set nomodified
	wincmd p
endfunction

" redirect the output of external command into preview window
function! shell#base#ShellCmdToPreview(cmd, append)
	if !a:append
		execute printf('pedit [%s]', a:cmd)
	endif

	try
		wincmd P
	catch /^Vim\%((\a\+)\)\=:E441:/
		call shell#base#ShellCmdToPreview(a:cmd, v:false)
		return
	endtry

	let l:vimcmd = a:append ? '$read !' :'%! '
	execute l:vimcmd.a:cmd
	setlocal nomodified
	wincmd p
endfunction
