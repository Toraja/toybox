inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
xnoremap <buffer> <silent> <M-;> :call edit#base#ToggleTrailing(';')<CR>

function! s:InitRustCmds()
	let l:rust_test_args = runcmds#init#MakeCmdArgsList([['--'], ['--show-output']])
	let l:override_cmds = {
				\ 'b': runcmds#init#MakeCmdInfo('Cbuild'),
				\ 'B': runcmds#init#MakeCmdInfo('RustToggleBackTrace'),
				\ 'g': runcmds#init#MakeCmdInfo('Cdebug'),
				\ 'r': runcmds#init#MakeCmdInfo('CrunIns'),
				\ 't': runcmds#init#MakeCmdInfo('RustTest', v:false, l:rust_test_args),
				\ 'T': runcmds#init#MakeCmdInfo('Ctest'),
				\ }
	let l:cmds = extend(DefaultCmds(), l:override_cmds)
	function! s:RustCmds() closure
		return l:cmds
	endfunction
endfunction
call s:InitRustCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Rust Cmds', <SID>RustCmds(), {})
