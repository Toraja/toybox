inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#Append(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#Append(';')<CR>
vnoremap <buffer> <silent> <M-;> :call edit#base#Append(';')<CR>

" This is useful for parameter signature added by autocompletion
inoremap <buffer> <silent> <C-q> <Left><C-o>cib

function! s:InitRustCmds()
	let l:override_cmds = {
				\ 'b': runcmds#init#MakeCmdInfo('Cbuild'),
				\ 'B': runcmds#init#MakeCmdInfo('RustToggleBackTrace'),
				\ 'g': runcmds#init#MakeCmdInfo('Cdebug'),
				\ 'r': runcmds#init#MakeCmdInfo('CrunIns'),
				\ 't': runcmds#init#MakeCmdInfo('RustTest'),
				\ 'T': runcmds#init#MakeCmdInfo('Ctest'),
				\ }
	let l:cmds = extend(DefaultCmds(), l:override_cmds)
	function! s:RustCmds() closure
		return l:cmds
	endfunction
endfunction
call s:InitRustCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Rust Cmds', <SID>RustCmds(), {})

let b:AutoPairs = extend(g:AutoPairs, {'<': '>'})
silent! call remove(b:AutoPairs, "'")
