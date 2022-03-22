setlocal conceallevel=2

highlight link VimwikiDelText Conceal
highlight link VimwikiCode Constant

nmap <buffer> o <Plug>VimwikiListo
nmap <buffer> O <Plug>VimwikiListO
nmap <buffer> <C-]> <Plug>VimwikiFollowLink
nmap <buffer> <C-t><C-]> <Plug>VimwikiTabnewLink
nmap <buffer> <C-w><C-]> <Plug>VimwikiVSplitLink

function! s:InitWikiCmds()
	let l:wiki_cmds = {
				\ 'c': runcmds#init#MakeCmdInfo('ConcealToggle'),
				\ 'd': runcmds#init#MakeCmdInfo('VimwikiToggleListItem'),
				\ 'D': runcmds#init#MakeCmdInfo('VimwikiRemoveSingleCB'),
				\ 'l': runcmds#init#MakeCmdInfo('VimwikiListToggleNoInsert'),
				\ 'p': runcmds#init#MakeCmdInfo('ToDoAddPomodoro'),
				\ 'r': runcmds#init#MakeCmdInfo('VimwikiIndex'),
				\ 's': runcmds#init#MakeCmdInfo('ToDoToggleStarted'),
				\ }
	function! s:WikiCmds() closure
		return l:wiki_cmds
	endfunction
endfunction
call s:InitWikiCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Wiki Cmds', <SID>WikiCmds(), {})

function! VimwikiListToggleNoInsert() abort
	let l:cmd = 'call vimwiki#lst#toggle_list_item()'
	call Preserve(l:cmd, 0, 0)
	stopinsert
endfunction
command! -buffer VimwikiListToggleNoInsert call VimwikiListToggleNoInsert()

function! ConcealToggle() abort
	execute printf('setlocal conceallevel=%d', &conceallevel ? 0 : 2)
endfunction
command! -buffer ConcealToggle call ConcealToggle()

let s:todo_line_ptn = '^\([ \t]*- \[.\+\]\) \(.*\)'
let s:started_symbol = 'STARTED '

function! ToDoToggleStarted() abort
	let l:line = getline('.')
	if !s:IsToDoLine(l:line)
		return
	endif

	if s:HasToDoStarted(l:line)
		call ToDoEnd(l:line)
	else
		call ToDoStart(l:line)
	endif
endfunction
command! -buffer ToDoToggleStarted call ToDoToggleStarted()

function! ToDoStart(line) abort
	call setline('.', substitute(a:line, s:todo_line_ptn, '\1 ' . s:started_symbol . '\2', ''))
endfunction

function! ToDoEnd(line) abort
	call setline('.', substitute(a:line, s:started_symbol, '', ''))
endfunction

function! s:HasToDoStarted(line) abort
	return match(a:line, s:started_symbol) > 0
endfunction

function! s:IsToDoLine(line) abort
	return match(a:line, s:todo_line_ptn) == 0
endfunction

function! ToDoAddPomodoro() abort
	let l:line = getline('.')
	if !s:IsToDoLine(l:line)
		echo 'Current line is not a ToDo'
		return
	endif
	if s:HasToDoLinePomodoro(l:line)
		echo 'This ToDo already has Pomodoro'
		return
	endif

	let l:count = Input(v:true, 'Pomodoro count: ')
	if empty(l:count)
		return
	endif
	call setline('.', getline('.') . printf(' [pmd: 0/%d]', l:count))
endfunction
command! -buffer ToDoAddPomodoro call ToDoAddPomodoro()

let s:pomodoro_ptn = '\[pmd: \d\+/\d+\]'
function! s:HasToDoLinePomodoro(line) abort
	return match(a:line, s:pomodoro_ptn) > 0
endfunction
