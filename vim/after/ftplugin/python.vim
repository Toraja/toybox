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
				\ 'r': 'Run',
				\ 'm': 'silent lmake | call LWindowSmart(winnr(), 10, 0)'
				\ }
endfunction

command! -buffer Run vsplit | terminal python %

command! -buffer Commander call Commander(<SID>PyCmds())
nnoremap <buffer> - :call Commander(<SID>PyCmds())<CR>
