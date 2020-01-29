" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:GoCmds()
			" \ 'b': (!has('nvim') && has('win32')) ? 'GoBuild %' : 'GoBuild',
			" \ 'B': printf('call MyMake("%s")', expand("%")),
	return {
				\ 'a': MakeRunCommandsDictInfo('GoAlternateSplit', v:false, v:true, ''),
				\ 'A': MakeRunCommandsDictInfo('GoAlternateVSplit', v:false, v:true, ''),
				\ 'b': MakeRunCommandsDictInfo('GoBuild', v:false, v:true, ''),
				\ 'B': MakeRunCommandsDictInfo('call MyMake()', v:false, v:false, ''),
				\ 'c': MakeRunCommandsDictInfo('GoCallers', v:false, v:false, ''),
				\ 'C': MakeRunCommandsDictInfo('GoCallees', v:false, v:false, ''),
				\ 'd': MakeRunCommandsDictInfo('GoDoc', v:false, v:false, 'customlist,go#package#Complete'),
				\ 'D': MakeRunCommandsDictInfo('GoDescribe', v:false, v:true, ''),
				\ 'e': MakeRunCommandsDictInfo('GoErrCheck', v:false, v:true, 'customlist,go#package#Complete'),
				\ 'f': MakeRunCommandsDictInfo('GoFillStruct', v:false, v:false, ''),
				\ 'F': MakeRunCommandsDictInfo('GoFmtAutoSaveToggle', v:false, v:false, ''),
				\ 'h': MakeRunCommandsDictInfo('!go test -bench .', v:false, v:false, ''),
				\ 'i': MakeRunCommandsDictInfo('GoAutoTypeInfoToggle', v:false, v:true, ''),
				\ 'I': MakeRunCommandsDictInfo('GoImport '.expand("<cword>"), v:false, v:false, ''),
				\ 'k': MakeRunCommandsDictInfo('GoCallstack', v:false, v:true, ''),
				\ 'l': MakeRunCommandsDictInfo('GoMetaLinter', v:false, v:true, ''),
				\ 'L': MakeRunCommandsDictInfo('GoMetaLinterAutoSaveToggle', v:false, v:false, ''),
				\ 'm': MakeRunCommandsDictInfo('GoImplements', v:false, v:false, ''),
				\ 'n': MakeRunCommandsDictInfo('call LanguageClient#textDocument_rename()', v:false, v:false, ''),
				\ 'o': MakeRunCommandsDictInfo('GoDecls', v:false, v:false, 'file'),
				\ 'O': MakeRunCommandsDictInfo('GoDeclsDir', v:false, v:false, 'dir'),
				\ 'p': MakeRunCommandsDictInfo('GoChannelPeers', v:false, v:false, ''),
				\ 'r': MakeRunCommandsDictInfo('GoRun %', v:false, v:true, 'file'),
				\ 'R': MakeRunCommandsDictInfo('GoReferrers', v:false, v:false, ''),
				\ 's': MakeRunCommandsDictInfo('GoSameIds', v:false, v:false, ''),
				\ 'S': MakeRunCommandsDictInfo('GoSameIdsClear', v:false, v:false, ''),
				\ 't': MakeRunCommandsDictInfo('GoTest', v:false, v:true, ''),
				\ 'T': MakeRunCommandsDictInfo('GoTestFunc', v:false, v:true, ''),
				\ 'v': MakeRunCommandsDictInfo('GoCoverage', v:false, v:true, ''),
				\ 'V': MakeRunCommandsDictInfo('GoCoverageClear', v:false, v:true, ''),
				\ 'w': MakeRunCommandsDictInfo('GoWhicherrs', v:false, v:false, ''),
				\ 'W': MakeRunCommandsDictInfo('SwitchTermMode "current mode = '.g:go_term_mode, v:false, v:false, ''),
				\ }
endfunction
command! -buffer RunCommands call RunCommands(<SID>GoCmds(), 'Go commands', {}, function('SortItemsByNestedValue', ['cmd']))
nnoremap <buffer> - :RunCommands<CR>
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

