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
	let l:cwd = getcwd()
	if !a:append
		execute printf('pedit +file\ [%s] %s', escape(a:cmd, ' \'), tempname())
	endif

	try
		wincmd P
	catch /^Vim\%((\a\+)\)\=:E441:/
		call shell#base#ShellCmdToPreview(a:cmd, v:false)
		return
	endtry

	execute 'cd ' . l:cwd
	let l:vimcmd = a:append ? '$read !' :'%! '
	execute l:vimcmd . a:cmd
	setlocal nomodified bufhidden=delete
	wincmd p
endfunction
