" value is l and c so that these can be simply prepended to quickfix commands
let [qf#base#qf_mode_location, qf#base#qf_mode_quickfix] = ['l', 'c']
let s:qf_mode = get(s:, 'qf_mode', qf#base#qf_mode_location)
let s:qf_mode_names = {
			\ qf#base#qf_mode_location: 'Location',
			\ qf#base#qf_mode_quickfix: 'Quickfix',
			\}

function! qf#base#QuickfixCmd(count)
	let l:title = s:qf_mode_names[s:qf_mode]
	call DispOptionsOneLine(l:title, {'<Space>': 'Display commands'})

	let l:cmd_dict = map(copy(s:QFCmds()), function('s:PrependQuickfixMode'))

	while v:true
		let l:user_input = GetChar(v:true)
		if l:user_input is 0
			return
		endif
		if l:user_input == "\<Space>"
			redraw
			call DispOptions(l:title . ':', l:cmd_dict, 'Press a key: ')
			continue
		else
			break
		endif
	endwhile
	redraw

	if IsCtrlAlpha(l:user_input)
		let l:user_input = ConvertCtrlCharToNormal(l:user_input, 1)
	endif

	let l:cmd = get(l:cmd_dict, l:user_input, '')
	if l:cmd is ''
		echohl WarningMsg | echo printf('"%s" is not available.', l:user_input) | echohl NONE
		return
	endif

	let l:count = (a:count == 0) ? "" : a:count
	if index(s:quickfix_cmd_config.no_count, l:user_input) < 0
		let l:cmd = printf('%s %s', l:cmd, l:count)
	endif

	try
		execute l:cmd
	catch /^Vim\%((\a\+)\)\=:E\(42\|776\):/
		echohl WarningMsg | echo 'No error in the list' | echohl NONE
		return
	catch
		redraw
		echohl ErrorMsg | echo printf('%s: %s', v:throwpoint, v:exception) | echohl NONE
	endtry
endfunction

" Toggle quickfix mode if no argument is supplied.
" Change to the mode if an argument is supplied.
" @1: mode to change
function! s:SwitchQFMode(...)
	if a:0 >= 1
		let l:mode_to_change = a:1
		let l:qf_modes = [g:qf#base#qf_mode_location, g:qf#base#qf_mode_quickfix]
		if index(l:qf_modes, l:mode_to_change) < 0
			echoerr 'Invalid Argument: must be either ' . string(l:qf_modes)
			return
		endif
		if s:qf_mode == l:mode_to_change
			return
		endif
	endif

	let l:mode_from = s:qf_mode_names[s:qf_mode]
	let s:qf_mode = s:qf_mode == g:qf#base#qf_mode_location ?
				\ g:qf#base#qf_mode_quickfix : g:qf#base#qf_mode_location
	let l:mode_to = s:qf_mode_names[s:qf_mode]
	echo printf('Quickfix mode changed from %s to %s', l:mode_from, l:mode_to)
endfunction
command! -bar -nargs=? SwitchQFMode call s:SwitchQFMode(<f-args>)

" Open quickfix/location list with just enough height for errors but
" no more than the maximum. Close window if no error is found.
" @qftype [number] quickfix of location
" @open_empty [boolean] whether to open quickfix window when there is no error
" @focus [boolean] whether to focus on quickfix window
" @return [number] the number of errors in location list
function! qf#base#QFOpenSmart(qftype, open_empty, focus) abort
	let l:numerror = a:qftype == g:qf#base#qf_mode_location ?
				\ len(getloclist(0)) : len(getqflist())
	if !(l:numerror || a:open_empty)
		execute a:qftype.'close'
		return 0
	endif

	silent call s:SwitchQFMode(a:qftype)

	const l:maxheight = 10
	let l:qfheight = max([min([l:numerror, l:maxheight]), 1])
	execute a:qftype.'open'.l:qfheight
	if !a:focus
		wincmd p
	endif

	return l:numerror
endf
command! -bang -nargs=+ QFOpenSmart call qf#base#QFOpenSmart(<f-args>, <bang>0)

function! s:QFCmds() abort
	return {
				\ 'o': 'QFOpenSmart! ' . s:qf_mode . ' 1',
				\ 'q': 'ToggleQFWindow ' . s:qf_mode,
				\ 's': 'close',
				\ 'g': s:qf_mode,
				\ 'n': 'next',
				\ 'p': 'previous',
				\ 'a': 'first',
				\ 'e': 'last',
				\ 'j': 'nfile',
				\ 'k': 'pfile',
				\ 'b': 'bottom',
				\ 'y': 'history',
				\ 'h': 'older',
				\ 'l': 'newer',
				\ 'm': printf('SwitchQFMode | " (current: %s)', s:qf_mode),
				\}
endfunction

let s:quickfix_cmd_config = {
			\ 'no_prepend_mode': ['o', 'q', 'm'],
			\ 'no_count': ['o', 'q', 's', 'b', 'y', 'm'],
			\}

function! s:PrependQuickfixMode(key, val)
	if index(s:quickfix_cmd_config.no_prepend_mode, a:key) >= 0
		return a:val
	endif
	return s:qf_mode . a:val
endfunction

function! s:ToggleQFWindow(qftype) abort
	let l:key = 'winid'
	let l:opt = {l:key: 1}
	let l:winid = a:qftype == g:qf#base#qf_mode_quickfix ? getqflist(l:opt)[l:key] : getloclist(0, l:opt)[l:key]
	if l:winid
		execute win_id2win(l:winid) . 'close'
		return
	endif
	call qf#base#QFOpenSmart(a:qftype, v:true, 0)
endfunction
command! -nargs=1 ToggleQFWindow call s:ToggleQFWindow(<q-args>)
