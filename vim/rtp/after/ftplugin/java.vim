setlocal matchpairs+==:;

" {{{ || keymap || ---
inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
xnoremap <buffer> <silent> <M-;> :call edit#base#ToggleTrailing(';')<CR>
" --- || keymap || }}}

cnoreabbrev cl JCclassNew
cnoreabbrev clf JCclassInFile

function! s:InitCmds()
	let l:cmds = DefaultCmds()
	" let l:cmds['r'] = runcmds#init#MakeCmdInfo('Run')
	" TODO change key char: let l:cmds.A = runcmds#init#MakeCmdInfo('JCgenerateAbstractMethods')
	let l:cmds.c = runcmds#init#MakeCmdInfo('JCgenerateConstructor')
	let l:cmds.C = runcmds#init#MakeCmdInfo('JCgenerateConstructorDefault')
	let l:cmds.e = runcmds#init#MakeCmdInfo('JCgenerateEqualsAndHashCode')
	let l:cmds.i = runcmds#init#MakeCmdInfo('JCimportsAddMissing')
	let l:cmds.I = runcmds#init#MakeCmdInfo('JCimportsRemoveUnused')
	let l:cmds.w = runcmds#init#MakeCmdInfo('JCgenerateAccessorSetterGetter')
	let l:cmds.x = runcmds#init#MakeCmdInfo('JCgenerateAccessors')
	function! s:GetCmds() closure
		return l:cmds
	endfunction
endfunction
call s:InitCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Run Cmds', <SID>GetCmds())
