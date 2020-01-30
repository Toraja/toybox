setlocal expandtab
setlocal nosmartindent
" setlocal textwidth=79 " commented out; let Autoformat do the work
setlocal fixendofline " python formatter requires EOL
setlocal makeprg=python\ %

augroup my_python
	autocmd!
	autocmd BufWrite *.py Autoformat
augroup end

function! s:MakePyCmds()
	let l:py_cmds = {
				\ 'r': MakeRunCommandsDictInfo('Run', [], v:false, v:false),
				\ 'm': MakeRunCommandsDictInfo('MyMake', [], v:false, v:false),
				\ }
	function! s:PyCmds() closure
		return l:py_cmds
	endfunction
endfunction
call s:MakePyCmds()
nnoremap <buffer> <expr> - RunCommandsExpr('Python Cmd', <SID>PyCmds())

command! -buffer Run vsplit | terminal python %
