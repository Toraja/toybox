highlight link mkdCode Constant
highlight link mkdStrike PmenuThumb

" {{{ || vim-markdown || ---
" loaded via vim-polyglot
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_no_default_key_mappings = 1
let g:vim_markdown_strikethrough = 1
" --- || vim-markdown || }}}

let s:todo_line_ptn = '^\([ \t]*- \[.\+\]\) \(.*\)'

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
