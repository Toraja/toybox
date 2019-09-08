" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:GoCmds()
			" \ 'b': (!has('nvim') && (has('win32') || has('win64'))) ? 'GoBuild %' : 'GoBuild',
			" \ 'B': printf('call MyMake("%s")', expand("%")),
	return {
				\ 'a': 'GoAlternateSplit',
				\ 'A': 'GoAlternateVSplit',
				\ 'b': 'GoBuild',
				\ 'B': 'call MyMake()',
				\ 'c': 'GoCallers',
				\ 'C': 'GoCallees',
				\ 'd': 'GoDoc',
				\ 'D': 'GoDescribe',
				\ 'e': 'GoErrCheck',
				\ 'f': 'GoFillStruct',
				\ 'F': 'GoFmtAutoSaveToggle',
				\ 'h': '!go test -bench .',
				\ 'i': 'GoAutoTypeInfoToggle',
				\ 'I': 'GoImport '.expand("<cword>"),
				\ 'k': 'GoCallstack',
				\ 'l': 'GoMetaLinter',
				\ 'L': 'GoMetaLinterAutoSaveToggle',
				\ 'm': 'GoImplements',
				\ 'n': 'call LanguageClient#textDocument_rename()',
				\ 'o': 'GoDecls',
				\ 'O': 'GoDeclsDir',
				\ 'p': 'GoChannelPeers',
				\ 'r': 'GoRun %',
				\ 'R': 'GoReferrers',
				\ 's': 'GoSameIds',
				\ 'S': 'GoSameIdsClear',
				\ 't': 'GoTest',
				\ 'T': 'GoTestFunc',
				\ 'v': 'GoCoverage',
				\ 'V': 'GoCoverageClear',
				\ 'w': 'GoWhicherrs',
				\ 'W': 'SwitchTermMode "current mode = '.g:go_term_mode,
				\ }
endfunction
command! RunGoCommands call RunGoCommands(<SID>GoCmds())
nnoremap <buffer> - :call RunGoCommands(<SID>GoCmds())<CR>
command! -bang GoAlternateSplit call go#alternate#Switch(<bang>0, 'split')
command! -bang GoAlternateVSplit call go#alternate#Switch(<bang>0, 'vsplit')

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
command! -nargs=1 GoDocOf call GoDocOf(<f-args>)

function! SwitchTermMode()
	let g:go_term_mode = (g:go_term_mode == 'vsplit') ? 'split' : 'vsplit'
	echo 'g:go_term_mode = '.g:go_term_mode
endfunction
command! -nargs=0 SwitchTermMode call SwitchTermMode()

if !has('nvim') && (has('win32') || has('win64'))
	" On Windows, it needs to be with '%'
	nnoremap <silent> <buffer> <F6> :GoBuild %<CR>
else
	" On Linux, it needs to be without '%'
	nnoremap <silent> <buffer> <F6> :GoBuild<CR>
endif
" nnoremap <silent> <buffer> <F7> :call MyMake(expand("%"))<CR>
nnoremap <silent> <buffer> <F7> :call MyMake()<CR>
nnoremap <silent> <buffer> <F8> :GoRun %<CR>
nnoremap <silent> <buffer> <Leader><F8> :GoRun<CR>
nnoremap <silent> <buffer> <F9> :GoTest<CR>
nnoremap <silent> <buffer> <Leader><F9> :GoTestFunc<CR>
nnoremap <silent> <buffer> <F10> :GoCoverageToggle<CR>
nnoremap <buffer> <F1> :GoDoc<CR>

nmap <buffer> gd <Plug>(go-def)
nmap <buffer> <C-]> <Plug>(go-def)
" use custom split/tab as vim-go providing function does not open window/tab
" if the destination is on the same file
nmap <buffer> <C-w><C-]> <C-w>s<Plug>(go-def)
nmap <buffer> <Leader><C-]> <C-w>v<Plug>(go-def)
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

