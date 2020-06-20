setlocal expandtab
setlocal nosmartindent
" setlocal textwidth=79 " commented out; let Autoformat do the work
setlocal fixendofline " python formatter requires EOL
setlocal makeprg=python\ %

augroup my_python
	autocmd!
	autocmd BufWrite *.py Autoformat
	" LanguageClient's formatter often crashes
	" autocmd BufWrite *.py call LanguageClient#textDocument_formatting()
augroup end

command! -buffer Run vsplit | terminal python %

function! s:InitPyCmds()
	let l:cmds = DefaultCmds()
	let l:cmds.r = runcmds#init#MakeCmdInfo('Run')
	function! s:PyCmds() closure
		return l:cmds
	endfunction
endfunction
call s:InitPyCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Py Cmds', <SID>PyCmds())
