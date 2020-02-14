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

function! s:InitPyCmds()
	let l:py_cmds = {
				\ 'f': runcmds#init#MakeCmdInfo('PyReference', [], v:false, v:false),
				\ 'i': runcmds#init#MakeCmdInfo('PyHover', [], v:false, v:false),
				\ 'r': runcmds#init#MakeCmdInfo('Run', [], v:false, v:false),
				\ 'm': runcmds#init#MakeCmdInfo('PyImplementation', [], v:false, v:false),
				\ 'n': runcmds#init#MakeCmdInfo('PyRename', [], v:false, v:false),
				\ 's': runcmds#init#MakeCmdInfo('PyDocHighlight', [], v:false, v:false),
				\ 'S': runcmds#init#MakeCmdInfo('PyDocHighlightClear', [], v:false, v:false),
				\ 'y': runcmds#init#MakeCmdInfo('PyDocSymbol', [], v:false, v:false),
				\ }
	function! s:PyCmds() closure
		return l:py_cmds
	endfunction
endfunction
call s:InitPyCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Py Cmds', <SID>PyCmds())

command! -buffer Run vsplit | terminal python %
command! -buffer PyDocHighlight call LanguageClient#textDocument_documentHighlight()
command! -buffer PyDocHighlightClear call LanguageClient#clearDocumentHighlight()
command! -buffer PyDocSymbol call LanguageClient#textDocument_documentSymbol()
command! -buffer PyHover call LanguageClient#textDocument_hover()
command! -buffer PyImplementation call LanguageClient#textDocument_implementation()
command! -buffer PyRename call LanguageClient#textDocument_rename()
command! -buffer PyReference call LanguageClient#textDocument_references()

nnoremap <buffer> <C-]> <Cmd>call LanguageClient#textDocument_definition()<CR>
nnoremap <buffer> [Chief]<C-]> <Cmd>vertical split \| call LanguageClient#textDocument_definition()<CR>
nnoremap <buffer> <C-t><C-]> <Cmd>tab split \| call LanguageClient#textDocument_definition()<CR>
