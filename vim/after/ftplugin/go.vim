" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:InitGocmds()
	let l:go_import_args = runcmds#init#MakeCmdArgsList([['expand("<cword>")', v:true]])
	let l:switch_term_mode_args = runcmds#init#MakeCmdArgsList([['"current mode ='], ['g:go_term_mode', v:true]])
	let l:go_run_args = runcmds#init#MakeCmdArgsList([['%']])
	let l:go_cmds = {
				\ 'a': runcmds#init#MakeCmdInfo('GoAlternateSplit', v:true),
				\ 'A': runcmds#init#MakeCmdInfo('GoAlternateVSplit', v:true),
				\ 'b': runcmds#init#MakeCmdInfo('GoBuild', v:true),
				\ 'B': runcmds#init#MakeCmdInfo('MyMake'),
				\ 'c': runcmds#init#MakeCmdInfo('GoCallers'),
				\ 'C': runcmds#init#MakeCmdInfo('GoCallees'),
				\ 'd': runcmds#init#MakeCmdInfo('GoDoc'),
				\ 'D': runcmds#init#MakeCmdInfo('GoDescribe', v:true),
				\ 'e': runcmds#init#MakeCmdInfo('GoErrCheck', v:true),
				\ 'f': runcmds#init#MakeCmdInfo('GoFillStruct'),
				\ 'F': runcmds#init#MakeCmdInfo('GoFmtAutoSaveToggle'),
				\ 'h': runcmds#init#MakeCmdInfo('!go test -bench .'),
				\ 'i': runcmds#init#MakeCmdInfo('GoAutoTypeInfoToggle', v:true),
				\ 'I': runcmds#init#MakeCmdInfo('GoImport', v:true, l:go_import_args),
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
				\ 's': runcmds#init#MakeCmdInfo('GoSameIds'),
				\ 'S': runcmds#init#MakeCmdInfo('GoSameIdsClear'),
				\ 't': runcmds#init#MakeCmdInfo('GoTest', v:true),
				\ 'T': runcmds#init#MakeCmdInfo('GoTestFunc', v:true),
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

cnoreabbrev bld GoBuild
cnoreabbrev cov GoCoverage
cnoreabbrev fm GoFmt
cnoreabbrev grs GoGuruScope
cnoreabbrev im GoImport
cnoreabbrev ima GoImportAs
cnoreabbrev ims GoImports
cnoreabbrev ml GoMetaLinter
cnoreabbrev mlt GoMetaLinterAutoSaveToggle

" --- || vim-go || }}}

