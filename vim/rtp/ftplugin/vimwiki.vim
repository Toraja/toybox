highlight link VimwikiDelText Conceal
highlight link VimwikiCode Constant

nmap <buffer> o <Plug>VimwikiListo
nmap <buffer> O <Plug>VimwikiListO
nmap <buffer> <C-]> <Plug>VimwikiFollowLink
nmap <buffer> <C-t><C-]> <Plug>VimwikiTabnewLink
nmap <buffer> <C-w><C-]> <Plug>VimwikiVSplitLink

let s:todo_line_ptn = '^\([ \t]*- \[.\+\]\) \(.*\)'
let s:started_symbol = 'STARTED '
let s:blocked_symbol = 'BLOCKED '

function! s:InitWikiCmds()
	let l:wiki_cmds = {
				\ 'b': runcmds#init#MakeCmdInfo('ToDoToggleStatus '.s:blocked_symbol),
				\ 'c': runcmds#init#MakeCmdInfo('ConcealToggle'),
				\ 'd': runcmds#init#MakeCmdInfo('VimwikiToggleListItem'),
				\ 'D': runcmds#init#MakeCmdInfo('VimwikiRemoveSingleCB'),
				\ 'l': runcmds#init#MakeCmdInfo('VimwikiListToggleNoInsert'),
				\ 'p': runcmds#init#MakeCmdInfo('ToDoAddPomodoro'),
				\ 'r': runcmds#init#MakeCmdInfo('VimwikiIndex'),
				\ 's': runcmds#init#MakeCmdInfo('ToDoToggleStatus '.s:started_symbol),
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

function! ToDoToggleStatus(status) abort
	let l:line = getline('.')
	if !s:IsToDoLine(l:line)
		return
	endif

	if s:IsToDoStatus(l:line, a:status)
		call ToDoRemoveStatus(l:line, a:status)
	else
		call ToDoAddStatus(l:line, a:status)
	endif
endfunction
command! -buffer -nargs=1 ToDoToggleStatus call ToDoToggleStatus(<f-args>)

function! ToDoAddStatus(line, status) abort
	call setline('.', substitute(a:line, s:todo_line_ptn, '\1 ' . a:status . '\2', ''))
endfunction

function! ToDoRemoveStatus(line, status) abort
	call setline('.', substitute(a:line, a:status, '', ''))
endfunction

function! s:IsToDoStatus(line, status) abort
	return match(a:line, a:status) > 0
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
