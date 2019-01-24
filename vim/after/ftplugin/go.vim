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
				\ 'f': 'GoReferrers',
				\ 'F': 'GoFmtAutoSaveToggle',
				\ 'h': '!go test -bench .',
				\ 'i': 'GoAutoTypeInfoToggle',
				\ 'I': 'GoImport '.expand("<cword>"),
				\ 'k': 'GoCallstack',
				\ 'l': 'GoMetaLinter',
				\ 'L': 'GoMetaLinterAutoSaveToggle',
				\ 'm': 'GoImplements',
				\ 'n': 'GoRename',
				\ 'o': 'GoDecls',
				\ 'O': 'GoDeclsDir',
				\ 'p': 'GoChannelPeers',
				\ 'r': 'GoRun %',
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
nmap <buffer> <C-w><C-]> 10<C-w>s<Plug>(go-def)
nmap <buffer> <Leader><C-]> <C-w>v<Plug>(go-def)
nmap <buffer> <C-t><C-]> :let [_, row, col, _, _] = getcurpos() <Bar> tabnew % <Bar> call cursor(row, col)<CR><Plug>(go-def)
nmap <buffer> [t <Plug>(go-def-pop)
nmap <buffer> ]t <Plug>(go-def-stack)

cnoreabbrev gb GoBuild
cnoreabbrev gdo GoDocOf
" cnoreabbrev gc GoCoverage		" disturbs substitute option
cnoreabbrev gf GoFmt
cnoreabbrev gft GoFmtAutoSaveToggle
cnoreabbrev ggs GoGuruScope
cnoreabbrev gi GoImport
cnoreabbrev gia GoImportAs
cnoreabbrev gis GoImports
cnoreabbrev gml GoMetaLinter
cnoreabbrev gmlt GoMetaLinterAutoSaveToggle
cnoreabbrev gr GoRun
cnoreabbrev gt GoTest
cnoreabbrev gtf GoTestFunc
cnoreabbrev gtc GoTestCompile

" XXX nvim loads plugins before ftplugin/go.vim -> g:go_doc_keywordprg_enabled
" will not be set by the time vim-go is loaded -> 'K' will be mapped as :GoDoc
" -> Remap the overridden keymap
nnoremap <buffer> K gT
" --- || vim-go || }}}

