setlocal expandtab
setlocal nosmartindent
" setlocal textwidth=79 " commented out; let Autoformat do the work
setlocal fixendofline " python formatter requires EOL
setlocal makeprg=python\ %

augroup my_python
	autocmd!
	autocmd BufWrite *.py Autoformat
augroup end


function! s:PyCmds()
	return {
				\ 'r': MakeRunCommandsDictInfo('Run', v:false, v:false, 'file'),
				\ 'm': MakeRunCommandsDictInfo('MyMake', v:false, v:false, ''),
				\ }
endfunction

command! -buffer Run vsplit | terminal python %

command! -buffer RunCommands call RunCommands(<SID>PyCmds(), 'Python Cmd')
nnoremap <buffer> - :RunCommands<CR>
