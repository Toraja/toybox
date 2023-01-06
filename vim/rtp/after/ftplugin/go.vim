setlocal shiftwidth=4 tabstop=4

function! s:InitGocmds()
	let l:go_cmds = {
				\ 'a': runcmds#init#MakeCmdInfo('GoAltV'),
				\ 'B': runcmds#init#MakeCmdInfo('!go test -bench .'),
				\ 'g': runcmds#init#MakeCmdInfo('GoDebug'),
				\ 'G': runcmds#init#MakeCmdInfo('GoBreakToggle'),
				\ 'h': runcmds#init#MakeCmdInfo('GoChannel'),
				\ 'k': runcmds#init#MakeCmdInfo('GoCallstack'),
				\ 'l': runcmds#init#MakeCmdInfo('GoLint'),
				\ 'r': runcmds#init#MakeCmdInfo('GoRun -F'),
				\ 's': runcmds#init#MakeCmdInfo('GoFillStruct'),
				\ 't': runcmds#init#MakeCmdInfo('GoAddTags'),
				\ 'T': runcmds#init#MakeCmdInfo('GoAddTest'),
				\ 'v': runcmds#init#MakeCmdInfo('GoCoverage'),
				\ 'V': runcmds#init#MakeCmdInfo('GoCoverage -t'),
				\ '0': runcmds#init#MakeCmdInfo('GoCodeAction'),
				\ '1': runcmds#init#MakeCmdInfo('GoCodeLenAct'),
				\ }
	let l:go_cmds = extend(DefaultCmds(), l:go_cmds)
	function! s:GoCmds() closure
		return l:go_cmds
	endfunction
endfunction
call s:InitGocmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Go Cmds', <SID>GoCmds(), {}, function('SortItemsByNestedValue', [runcmds#init#cmd_info_key_cmd]))
