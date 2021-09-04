" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:InitGocmds()
	let l:go_import_args = runcmds#init#MakeCmdArgsList([['expand("<cword>")', v:true]])
	let l:switch_term_mode_args = runcmds#init#MakeCmdArgsList([['"current mode ='], ['g:go_term_mode', v:true]])
	let l:go_run_args = runcmds#init#MakeCmdArgsList([['%']])
	let l:go_cmds = {
				\ 'a': runcmds#init#MakeCmdInfo('GoAlternateVSplit', v:true),
				\ 'b': runcmds#init#MakeCmdInfo('GoBuild', v:true),
				\ 'B': runcmds#init#MakeCmdInfo('!go test -bench .'),
				\ 'c': runcmds#init#MakeCmdInfo('GoCallers'),
				\ 'C': runcmds#init#MakeCmdInfo('GoCallees'),
				\ 'd': runcmds#init#MakeCmdInfo('GoDoc'),
				\ 'D': runcmds#init#MakeCmdInfo('GoDescribe', v:true),
				\ 'e': runcmds#init#MakeCmdInfo('GoErrCheck', v:true),
				\ 'F': runcmds#init#MakeCmdInfo('GoFmtAutoSaveToggle'),
				\ 'g': runcmds#init#MakeCmdInfo('GoDebugTestFunc'),
				\ 'h': runcmds#init#MakeCmdInfo('GoSameIds'),
				\ 'H': runcmds#init#MakeCmdInfo('GoSameIdsClear'),
				\ 'i': runcmds#init#MakeCmdInfo('GoImport', v:true, l:go_import_args),
				\ 'I': runcmds#init#MakeCmdInfo('GoAutoTypeInfoToggle', v:true),
				\ 'k': runcmds#init#MakeCmdInfo('GoCallstack', v:true),
				\ 'l': runcmds#init#MakeCmdInfo('GoMetaLinter', v:true),
				\ 'L': runcmds#init#MakeCmdInfo('GoMetaLinterAutoSaveToggle'),
				\ 'm': runcmds#init#MakeCmdInfo('GoImplements'),
				\ 'n': runcmds#init#MakeCmdInfo('call LanguageClient#textDocument_rename()'),
				\ 'o': runcmds#init#MakeCmdInfo('GoDecls'),
				\ 'O': runcmds#init#MakeCmdInfo('GoDeclsDir'),
				\ 'p': runcmds#init#MakeCmdInfo('GoChannelPeers'),
				\ 'r': runcmds#init#MakeCmdInfo('GoRun', v:true, l:go_run_args),
				\ 'R': runcmds#init#MakeCmdInfo('GoReferrers'),
				\ 's': runcmds#init#MakeCmdInfo('GoFillStruct'),
				\ 't': runcmds#init#MakeCmdInfo('TestNearest -v', v:true),
				\ 'T': runcmds#init#MakeCmdInfo('GoTest', v:true),
				\ 'v': runcmds#init#MakeCmdInfo('GoCoverage', v:true),
				\ 'V': runcmds#init#MakeCmdInfo('GoCoverageClear', v:true),
				\ 'w': runcmds#init#MakeCmdInfo('GoWhicherrs'),
				\ 'W': runcmds#init#MakeCmdInfo('SwitchTermMode', v:false, l:switch_term_mode_args),
				\ }
	function! s:GoCmds() closure
		return l:go_cmds
	endfunction
endfunction
call s:InitGocmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Go Cmds', <SID>GoCmds(), {}, function('SortItemsByNestedValue', [runcmds#init#cmd_info_key_cmd]))
command! -buffer -bang GoAlternateSplit call go#alternate#Switch(<bang>0, 'split')
command! -buffer -bang GoAlternateVSplit call go#alternate#Switch(<bang>0, 'vsplit')

function! SwitchTermMode()
	let g:go_term_mode = (g:go_term_mode == 'vsplit') ? 'split' : 'vsplit'
	echo 'g:go_term_mode = '.g:go_term_mode
endfunction
command! -buffer -nargs=0 SwitchTermMode call SwitchTermMode()

nmap <buffer> gd <Plug>(go-def)
nmap <buffer> <C-]> <Plug>(go-def)
" use custom split/tab as vim-go providing function does not open window/tab
" if the destination is on the same file
nmap <buffer> <C-w><C-]> <C-w>s<Plug>(go-def)
nmap <buffer> [Chief]<C-]> <C-w>v<Plug>(go-def)
nmap <buffer> <C-t><C-]> :tab split<CR><Plug>(go-def)
nmap <buffer> [t <Plug>(go-def-pop)
nmap <buffer> ]t <Plug>(go-def-stack)

cnoreabbrev gbl GoBuild
cnoreabbrev gcv GoCoverage
cnoreabbrev gfm GoFmt
cnoreabbrev ggs GoGuruScope
cnoreabbrev gim GoImport
cnoreabbrev gima GoImportAs
cnoreabbrev gims GoImports
cnoreabbrev gml GoMetaLinter
cnoreabbrev gmlt GoMetaLinterAutoSaveToggle

" --- || vim-go || }}}

