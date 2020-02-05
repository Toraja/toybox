setlocal expandtab
setlocal nosmartindent
" setlocal textwidth=79 " commented out; let Autoformat do the work
setlocal fixendofline " python formatter requires EOL
setlocal makeprg=python\ %

augroup my_python
	autocmd!
	autocmd BufWrite *.py Autoformat
augroup end

function! s:InitPyCmds()
	let l:py_cmds = {
				\ 'r': runcmds#init#MakeCmdInfo('Run', [], v:false, v:false),
				\ 'm': runcmds#init#MakeCmdInfo('MyMake', [], v:false, v:false),
				\ }
	function! s:PyCmds() closure
		return l:py_cmds
	endfunction
endfunction
call s:InitPyCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Py Cmds', <SID>PyCmds())

command! -buffer Run vsplit | terminal python %
