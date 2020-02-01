" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:MakeGocmds()
	let l:go_import_args = MakeRunCommandsDictInfoArgs([['expand("<cword>")', v:true]])
	let l:switch_term_mode_args = MakeRunCommandsDictInfoArgs([['"current mode ='], ['g:go_term_mode', v:true]])
	let l:go_run_args = MakeRunCommandsDictInfoArgs([['%']])
	let l:go_cmds = {
				\ 'a': MakeRunCommandsDictInfo('GoAlternateSplit', [], v:false, v:true),
				\ 'A': MakeRunCommandsDictInfo('GoAlternateVSplit', [], v:false, v:true),
				\ 'b': MakeRunCommandsDictInfo('GoBuild', [], v:false, v:true),
				\ 'B': MakeRunCommandsDictInfo('MyMake', [], v:false, v:false),
				\ 'c': MakeRunCommandsDictInfo('GoCallers', [], v:false, v:false),
				\ 'C': MakeRunCommandsDictInfo('GoCallees', [], v:false, v:false),
				\ 'd': MakeRunCommandsDictInfo('GoDoc', [], v:false, v:false),
				\ 'D': MakeRunCommandsDictInfo('GoDescribe', [], v:false, v:true),
				\ 'e': MakeRunCommandsDictInfo('GoErrCheck', [], v:false, v:true),
				\ 'f': MakeRunCommandsDictInfo('GoFillStruct', [], v:false, v:false),
				\ 'F': MakeRunCommandsDictInfo('GoFmtAutoSaveToggle', [], v:false, v:false),
				\ 'h': MakeRunCommandsDictInfo('!go test -bench .', [], v:false, v:false),
				\ 'i': MakeRunCommandsDictInfo('GoAutoTypeInfoToggle', [], v:false, v:true),
				\ 'I': MakeRunCommandsDictInfo('GoImport', l:go_import_args, v:false, v:true),
				\ 'k': MakeRunCommandsDictInfo('GoCallstack', [], v:false, v:true),
				\ 'l': MakeRunCommandsDictInfo('GoMetaLinter', [], v:false, v:true),
				\ 'L': MakeRunCommandsDictInfo('GoMetaLinterAutoSaveToggle', [], v:false, v:false),
				\ 'm': MakeRunCommandsDictInfo('GoImplements', [], v:false, v:false),
				\ 'n': MakeRunCommandsDictInfo('call LanguageClient#textDocument_rename()', [], v:false, v:false),
				\ 'o': MakeRunCommandsDictInfo('GoDecls', [], v:false, v:false),
				\ 'O': MakeRunCommandsDictInfo('GoDeclsDir', [], v:false, v:false),
				\ 'p': MakeRunCommandsDictInfo('GoChannelPeers', [], v:false, v:false),
				\ 'r': MakeRunCommandsDictInfo('GoRun', l:go_run_args, v:false, v:true),
				\ 'R': MakeRunCommandsDictInfo('GoReferrers', [], v:false, v:false),
				\ 's': MakeRunCommandsDictInfo('GoSameIds', [], v:false, v:false),
				\ 'S': MakeRunCommandsDictInfo('GoSameIdsClear', [], v:false, v:false),
				\ 't': MakeRunCommandsDictInfo('GoTest', [], v:false, v:true),
				\ 'T': MakeRunCommandsDictInfo('GoTestFunc', [], v:false, v:true),
				\ 'v': MakeRunCommandsDictInfo('GoCoverage', [], v:false, v:true),
				\ 'V': MakeRunCommandsDictInfo('GoCoverageClear', [], v:false, v:true),
				\ 'w': MakeRunCommandsDictInfo('GoWhicherrs', [], v:false, v:false),
				\ 'W': MakeRunCommandsDictInfo('SwitchTermMode', l:switch_term_mode_args, v:false, v:false),
				\ }
	function! s:GoCmds() closure
		return l:go_cmds
	endfunction
endfunction
call s:MakeGocmds()
nnoremap <buffer> <expr> - RunCommands('Go commands', <SID>GoCmds(), {}, function('SortItemsByNestedValue', ['cmd']))
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

