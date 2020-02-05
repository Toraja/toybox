" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:InitGocmds()
	let l:go_import_args = runcmds#init#MakeDictInfoArgs([['expand("<cword>")', v:true]])
	let l:switch_term_mode_args = runcmds#init#MakeDictInfoArgs([['"current mode ='], ['g:go_term_mode', v:true]])
	let l:go_run_args = runcmds#init#MakeDictInfoArgs([['%']])
	let l:go_cmds = {
				\ 'a': runcmds#init#MakeDictInfo('GoAlternateSplit', [], v:false, v:true),
				\ 'A': runcmds#init#MakeDictInfo('GoAlternateVSplit', [], v:false, v:true),
				\ 'b': runcmds#init#MakeDictInfo('GoBuild', [], v:false, v:true),
				\ 'B': runcmds#init#MakeDictInfo('MyMake', [], v:false, v:false),
				\ 'c': runcmds#init#MakeDictInfo('GoCallers', [], v:false, v:false),
				\ 'C': runcmds#init#MakeDictInfo('GoCallees', [], v:false, v:false),
				\ 'd': runcmds#init#MakeDictInfo('GoDoc', [], v:false, v:false),
				\ 'D': runcmds#init#MakeDictInfo('GoDescribe', [], v:false, v:true),
				\ 'e': runcmds#init#MakeDictInfo('GoErrCheck', [], v:false, v:true),
				\ 'f': runcmds#init#MakeDictInfo('GoFillStruct', [], v:false, v:false),
				\ 'F': runcmds#init#MakeDictInfo('GoFmtAutoSaveToggle', [], v:false, v:false),
				\ 'h': runcmds#init#MakeDictInfo('!go test -bench .', [], v:false, v:false),
				\ 'i': runcmds#init#MakeDictInfo('GoAutoTypeInfoToggle', [], v:false, v:true),
				\ 'I': runcmds#init#MakeDictInfo('GoImport', l:go_import_args, v:false, v:true),
				\ 'k': runcmds#init#MakeDictInfo('GoCallstack', [], v:false, v:true),
				\ 'l': runcmds#init#MakeDictInfo('GoMetaLinter', [], v:false, v:true),
				\ 'L': runcmds#init#MakeDictInfo('GoMetaLinterAutoSaveToggle', [], v:false, v:false),
				\ 'm': runcmds#init#MakeDictInfo('GoImplements', [], v:false, v:false),
				\ 'n': runcmds#init#MakeDictInfo('call LanguageClient#textDocument_rename()', [], v:false, v:false),
				\ 'o': runcmds#init#MakeDictInfo('GoDecls', [], v:false, v:false),
				\ 'O': runcmds#init#MakeDictInfo('GoDeclsDir', [], v:false, v:false),
				\ 'p': runcmds#init#MakeDictInfo('GoChannelPeers', [], v:false, v:false),
				\ 'r': runcmds#init#MakeDictInfo('GoRun', l:go_run_args, v:false, v:true),
				\ 'R': runcmds#init#MakeDictInfo('GoReferrers', [], v:false, v:false),
				\ 's': runcmds#init#MakeDictInfo('GoSameIds', [], v:false, v:false),
				\ 'S': runcmds#init#MakeDictInfo('GoSameIdsClear', [], v:false, v:false),
				\ 't': runcmds#init#MakeDictInfo('GoTest', [], v:false, v:true),
				\ 'T': runcmds#init#MakeDictInfo('GoTestFunc', [], v:false, v:true),
				\ 'v': runcmds#init#MakeDictInfo('GoCoverage', [], v:false, v:true),
				\ 'V': runcmds#init#MakeDictInfo('GoCoverageClear', [], v:false, v:true),
				\ 'w': runcmds#init#MakeDictInfo('GoWhicherrs', [], v:false, v:false),
				\ 'W': runcmds#init#MakeDictInfo('SwitchTermMode', l:switch_term_mode_args, v:false, v:false),
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

