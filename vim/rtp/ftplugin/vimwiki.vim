setlocal conceallevel=2

let g:vimwiki_key_mappings = {
			\ 'all_maps': 0,
			\ 'global': 0,
			\ 'headers': 1,
			\ 'text_objs': 0,
			\ 'table_format': 0,
			\ 'table_mappings': 0,
			\ 'lists': 0,
			\ 'links': 0,
			\ 'html': 0,
			\ 'mouse': 0,
			\ }

function! s:InitWikiCmds()
	let l:wiki_cmds = {
				\ 'c': runcmds#init#MakeCmdInfo('ConcealToggle'),
				\ 'd': runcmds#init#MakeCmdInfo('VimwikiToggleListItem'),
				\ 'g': runcmds#init#MakeCmdInfo('VimwikiTabnewLink'),
				\ 'l': runcmds#init#MakeCmdInfo('VimwikiListToggle'),
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

function! ConcealToggle() abort
	execute printf('setlocal conceallevel=%d', &conceallevel ? 0 : 2)
endfunction
command! -buffer ConcealToggle call ConcealToggle()

let s:todo_line_ptn = '^\(\t*- \[.\+\]\) \(.*\)'
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
