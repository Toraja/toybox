" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:InitGocmds()
	let l:go_import_args = runcmds#init#MakeCmdArgsList([['expand("<cword>")', v:true]])
	let l:switch_term_mode_args = runcmds#init#MakeCmdArgsList([['"current mode ='], ['g:go_term_mode', v:true]])
	let l:go_run_args = runcmds#init#MakeCmdArgsList([['%']])
	let l:go_cmds = {
				\ 'a': runcmds#init#MakeCmdInfo('GoAlternateSplit', [], v:false, v:true),
				\ 'A': runcmds#init#MakeCmdInfo('GoAlternateVSplit', [], v:false, v:true),
				\ 'b': runcmds#init#MakeCmdInfo('GoBuild', [], v:false, v:true),
				\ 'B': runcmds#init#MakeCmdInfo('MyMake', [], v:false, v:false),
				\ 'c': runcmds#init#MakeCmdInfo('GoCallers', [], v:false, v:false),
				\ 'C': runcmds#init#MakeCmdInfo('GoCallees', [], v:false, v:false),
				\ 'd': runcmds#init#MakeCmdInfo('GoDoc', [], v:false, v:false),
				\ 'D': runcmds#init#MakeCmdInfo('GoDescribe', [], v:false, v:true),
				\ 'e': runcmds#init#MakeCmdInfo('GoErrCheck', [], v:false, v:true),
				\ 'f': runcmds#init#MakeCmdInfo('GoFillStruct', [], v:false, v:false),
				\ 'F': runcmds#init#MakeCmdInfo('GoFmtAutoSaveToggle', [], v:false, v:false),
				\ 'h': runcmds#init#MakeCmdInfo('!go test -bench .', [], v:false, v:false),
				\ 'i': runcmds#init#MakeCmdInfo('GoAutoTypeInfoToggle', [], v:false, v:true),
				\ 'I': runcmds#init#MakeCmdInfo('GoImport', l:go_import_args, v:false, v:true),
				\ 'k': runcmds#init#MakeCmdInfo('GoCallstack', [], v:false, v:true),
				\ 'l': runcmds#init#MakeCmdInfo('GoMetaLinter', [], v:false, v:true),
				\ 'L': runcmds#init#MakeCmdInfo('GoMetaLinterAutoSaveToggle', [], v:false, v:false),
				\ 'm': runcmds#init#MakeCmdInfo('GoImplements', [], v:false, v:false),
				\ 'n': runcmds#init#MakeCmdInfo('call LanguageClient#textDocument_rename()', [], v:false, v:false),
				\ 'o': runcmds#init#MakeCmdInfo('GoDecls', [], v:false, v:false),
				\ 'O': runcmds#init#MakeCmdInfo('GoDeclsDir', [], v:false, v:false),
				\ 'p': runcmds#init#MakeCmdInfo('GoChannelPeers', [], v:false, v:false),
				\ 'r': runcmds#init#MakeCmdInfo('GoRun', l:go_run_args, v:false, v:true),
				\ 'R': runcmds#init#MakeCmdInfo('GoReferrers', [], v:false, v:false),
				\ 's': runcmds#init#MakeCmdInfo('GoSameIds', [], v:false, v:false),
				\ 'S': runcmds#init#MakeCmdInfo('GoSameIdsClear', [], v:false, v:false),
				\ 't': runcmds#init#MakeCmdInfo('GoTest', [], v:false, v:true),
				\ 'T': runcmds#init#MakeCmdInfo('GoTestFunc', [], v:false, v:true),
				\ 'v': runcmds#init#MakeCmdInfo('GoCoverage', [], v:false, v:true),
				\ 'V': runcmds#init#MakeCmdInfo('GoCoverageClear', [], v:false, v:true),
				\ 'w': runcmds#init#MakeCmdInfo('GoWhicherrs', [], v:false, v:false),
				\ 'W': runcmds#init#MakeCmdInfo('SwitchTermMode', l:switch_term_mode_args, v:false, v:false),
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

