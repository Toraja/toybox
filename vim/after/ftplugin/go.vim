" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:InitGocmds()
	let l:go_import_args = MakeRunCmdsDictInfoArgs([['expand("<cword>")', v:true]])
	let l:switch_term_mode_args = MakeRunCmdsDictInfoArgs([['"current mode ='], ['g:go_term_mode', v:true]])
	let l:go_run_args = MakeRunCmdsDictInfoArgs([['%']])
	let l:go_cmds = {
				\ 'a': MakeRunCmdsDictInfo('GoAlternateSplit', [], v:false, v:true),
				\ 'A': MakeRunCmdsDictInfo('GoAlternateVSplit', [], v:false, v:true),
				\ 'b': MakeRunCmdsDictInfo('GoBuild', [], v:false, v:true),
				\ 'B': MakeRunCmdsDictInfo('MyMake', [], v:false, v:false),
				\ 'c': MakeRunCmdsDictInfo('GoCallers', [], v:false, v:false),
				\ 'C': MakeRunCmdsDictInfo('GoCallees', [], v:false, v:false),
				\ 'd': MakeRunCmdsDictInfo('GoDoc', [], v:false, v:false),
				\ 'D': MakeRunCmdsDictInfo('GoDescribe', [], v:false, v:true),
				\ 'e': MakeRunCmdsDictInfo('GoErrCheck', [], v:false, v:true),
				\ 'f': MakeRunCmdsDictInfo('GoFillStruct', [], v:false, v:false),
				\ 'F': MakeRunCmdsDictInfo('GoFmtAutoSaveToggle', [], v:false, v:false),
				\ 'h': MakeRunCmdsDictInfo('!go test -bench .', [], v:false, v:false),
				\ 'i': MakeRunCmdsDictInfo('GoAutoTypeInfoToggle', [], v:false, v:true),
				\ 'I': MakeRunCmdsDictInfo('GoImport', l:go_import_args, v:false, v:true),
				\ 'k': MakeRunCmdsDictInfo('GoCallstack', [], v:false, v:true),
				\ 'l': MakeRunCmdsDictInfo('GoMetaLinter', [], v:false, v:true),
				\ 'L': MakeRunCmdsDictInfo('GoMetaLinterAutoSaveToggle', [], v:false, v:false),
				\ 'm': MakeRunCmdsDictInfo('GoImplements', [], v:false, v:false),
				\ 'n': MakeRunCmdsDictInfo('call LanguageClient#textDocument_rename()', [], v:false, v:false),
				\ 'o': MakeRunCmdsDictInfo('GoDecls', [], v:false, v:false),
				\ 'O': MakeRunCmdsDictInfo('GoDeclsDir', [], v:false, v:false),
				\ 'p': MakeRunCmdsDictInfo('GoChannelPeers', [], v:false, v:false),
				\ 'r': MakeRunCmdsDictInfo('GoRun', l:go_run_args, v:false, v:true),
				\ 'R': MakeRunCmdsDictInfo('GoReferrers', [], v:false, v:false),
				\ 's': MakeRunCmdsDictInfo('GoSameIds', [], v:false, v:false),
				\ 'S': MakeRunCmdsDictInfo('GoSameIdsClear', [], v:false, v:false),
				\ 't': MakeRunCmdsDictInfo('GoTest', [], v:false, v:true),
				\ 'T': MakeRunCmdsDictInfo('GoTestFunc', [], v:false, v:true),
				\ 'v': MakeRunCmdsDictInfo('GoCoverage', [], v:false, v:true),
				\ 'V': MakeRunCmdsDictInfo('GoCoverageClear', [], v:false, v:true),
				\ 'w': MakeRunCmdsDictInfo('GoWhicherrs', [], v:false, v:false),
				\ 'W': MakeRunCmdsDictInfo('SwitchTermMode', l:switch_term_mode_args, v:false, v:false),
				\ }
	function! s:GoCmds() closure
		return l:go_cmds
	endfunction
endfunction
call s:InitGocmds()
nnoremap <buffer> <expr> - RunCmds('Go Cmds', <SID>GoCmds(), {}, function('SortItemsByNestedValue', ['cmd']))
command! -buffer -bang GoAlternateSplit call go#alternate#Switch(<bang>0, 'split')
command! -buffer -bang GoAlternateVSplit call go#alternate#Switch(<bang>0, 'vsplit')

" TODO file name of the status bar will still be the tempname() (redraw does not work)
function! GoDocOf(item) abort
	let l:regbk = @"
	call setreg('"', system('go doc '.a:item))

	if v:shell_error != 0
		echohl ErrorMsg | echo a:item.' was not found' | echohl NONE
		return
	endif

	let l:orgwinnr = winnr()
	let l:tf = tempname()
	silent execute "pedit ".l:tf
	let l:pwinnr = bufwinnr(l:tf)
	execute l:pwinnr . "wincmd w"
	setlocal modifiable noreadonly
	silent put!
	silent execute "file [go doc]".a:item
	" prevent from accidentally saving preview file
	setlocal nomodifiable nomodified readonly
	goto
	setlocal bufhidden=delete	" delete buffer when preview window is closed
	" adjust winheight
	let l:controw = line('$')
	if winheight(winnr()) > l:controw
		execute l:controw."wincmd _"
	endif

	call setreg('"', l:regbk)
	execute l:orgwinnr . "wincmd w"
endfunction
command! -buffer -nargs=1 GoDocOf call GoDocOf(<f-args>)

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
cnoreabbrev doc GoDocOf
cnoreabbrev cov GoCoverage
cnoreabbrev fm GoFmt
cnoreabbrev grs GoGuruScope
cnoreabbrev im GoImport
cnoreabbrev ima GoImportAs
cnoreabbrev ims GoImports
cnoreabbrev ml GoMetaLinter
cnoreabbrev mlt GoMetaLinterAutoSaveToggle

" --- || vim-go || }}}

