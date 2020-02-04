function! runcmds#base#RunCmds(title, cmds, ...) abort
	let l:flag_symbols = get(a:000, 0, {})
	let l:SortFunc = get(a:000, 1, '')

	function! s:EvalCmdArgs(cmd_key, cmd_info) abort
		let l:cmd_info = copy(a:cmd_info)

		if empty(a:cmd_info.args)
			let l:cmd_info.desc = l:cmd_info.cmd
			return l:cmd_info
		endif

		let l:new_args = []
		for l:arg in l:cmd_info.args
			call add(l:new_args, l:arg.eval ? eval(l:arg.value) : l:arg.value)
		endfor
		let l:cmd_info.args = l:new_args
		let l:cmd_info.desc = l:cmd_info.cmd . ' ' . join(l:new_args, ' ')
		return l:cmd_info
	endfunction

	let l:cmds_string = ''
	function! s:UpdateDisplay() closure
		if l:cmds_string is ''
			let l:cmds_string = s:DictToListString(l:cmds, ': ', '  ', '', l:SortFunc, 'desc')
		endif
		let l:selected_flags = l:flags.selected_flags()
		let l:selected_flags_display = strlen(l:selected_flags) == 0 ?
					\ '' : printf('(%s)', l:flags.selected_flags())
		redraw
		if l:flag_disp.selected
			call s:EchoAdjustingCmdheight(l:cmds_string, a:title,
						\ 'Press a key > ' . l:selected_flags_display,
						\ v:false)
		else
			call l:DisplayOptionPrompt()
			echon l:selected_flags_display
		endif
	endfunction

	let l:flag_info = {}
	function! l:flag_info.new(desc)
		let l:info = copy(self)
		let l:info.selected = v:false
		let l:info.desc = a:desc
		return l:info
	endfunction
	function! l:flag_info.toggle_selected()
		let self.selected = !self.selected
	endfunction

	let l:flag_mod = l:flag_info.new('Modify command')
	let l:flag_disp = l:flag_info.new('Display commands')
	let l:flag_bang = l:flag_info.new('Run with !')

	let l:flags = {}
	let l:flags.registry = {
				\ get(l:flag_symbols, 'mod', '-'): l:flag_mod,
				\ get(l:flag_symbols, 'disp', '_'): l:flag_disp,
				\ get(l:flag_symbols, 'bang', '!'): l:flag_bang,
				\}
	function! l:flags.all()
		return self.registry
	endfunction
	function! l:flags.info_of(flag_symbol)
		return get(self.registry, a:flag_symbol, {})
	endfunction
	function! l:flags.selected_flags()
		let l:selected_flags = ''
		for [l:flag_symbol, l:flag_info] in items(self.all())
			if l:flag_info.selected
				let l:selected_flags .= l:flag_symbol
			endif
		endfor
		return l:selected_flags
	endfunction

	let l:flag_option_str = DictToOneLineString(l:flags.all(), ', ', '', 'desc')
	let l:DisplayOptionPrompt = function('s:DisplayOptionPrompt', [a:title, l:flag_option_str])
	call l:DisplayOptionPrompt()

	let l:cmds = map(copy(a:cmds), function('s:EvalCmdArgs'))

	while v:true
		let l:user_input = GetChar(v:true)
		if l:user_input is 0
			return
		endif

		let l:flag_info = l:flags.info_of(l:user_input)
		if empty(l:flag_info)
			break
		endif
		call l:flag_info.toggle_selected()
		call s:UpdateDisplay()
	endwhile
	mode

	let l:cmd_info = get(l:cmds, l:user_input, {})
	if empty(l:cmd_info)
		" user press an unavailable key
		echohl WarningMsg | echo printf('"%s" is not available.', l:user_input) | echohl NONE
		return
	endif

	if !l:flag_mod.selected && l:cmd_info.always_modify
		call l:flag_mod.toggle_selected()
	endif
	let l:cmd = l:cmd_info.cmd
	if l:flag_bang.selected && l:cmd_info.bangable
		let l:cmd .= '!'
	endif
	let l:arg = len(l:cmd_info.args) == 0 ? '' : ' ' . join(l:cmd_info.args)

	return ':' . l:cmd . l:arg . (l:flag_mod.selected ? "\<Space>": "\<CR>")
endfunction

function! s:DisplayOptionPrompt(title, option_str) abort
	mode
	echohl MatchParen | echo a:title | echohl None
	echon printf(' %s > ', a:option_str)
endfunction

" @dict [dict] dictionary
" @sep [string] separator for key and value
" @1 [string] prefix for each entry
" @2 [string] suffiix for each entry
" @3 [*] {func} argument for sort()
" @4 [string] if {dict} has nested dict, key for the entry to use
function! s:DictToListString(dict, sep, ...) abort
	let l:prefix = get(a:000, 0, ', ')
	let l:suffix = get(a:000, 1, ', ')
	let l:SortFunc = get(a:000, 2, '')
	let l:key_name = get(a:000, 3, '')

	let l:entry_format = l:prefix. '%s' . a:sep . '%s' . l:suffix
	let l:list = []
	for [k, v] in sort(items(a:dict), l:SortFunc)
		call add(l:list, printf(l:entry_format, k, (type(v) == v:t_dict ? v[l:key_name] : v)))
	endfor
	unlet k v

	return join(l:list, "\n")
endfunction

" `echo` without "Press ENTER and ..." by changing 'cmdheight' if {content}
" has more line number than 'cmdheight'.
" If {return_callback} is true, you can reset the 'cmdheight' by calling
" `reset_cmdheight()` of returned object. Otherwise 'cmdheight' is reset
" immediately (intended to use with getchar/input())
function! s:EchoAdjustingCmdheight(content, header, footer, return_callback) abort
	" let l:org_cmdheight = &cmdheight
	" let l:cmdheight_changed = v:false

	" let l:line_count = count(a:content, "\n") + 1
	" if a:header != ''
	"     let l:line_count += count(a:header, "\n") + 1
	" endif
	" if a:footer != ''
	"     let l:line_count += count(a:footer, "\n") + 1
	" endif
	" if l:line_count > &cmdheight
	"     let l:winheights = SaveWinheight()
	"     " must be `let`, `execute set` does not work
	"     let &cmdheight = l:line_count
	"     let l:cmdheight_changed = v:true
	" endif

	mode " suppress white flash which somehow appears when expanding cmdline
	" `echo` after the first time erase previous content, use `echon` instead
	if a:header != ''
		echohl MatchParen | echo a:header | echohl NONE
	endif
	echon "\n" . a:content
	if a:footer != ''
		echohl Question | echon "\n" . a:footer | echohl NONE
	endif

	" if a:return_callback
	"     let l:callback = {}
	"     function! l:callback.reset_cmdheight() closure
	"         if l:cmdheight_changed
	"             let &cmdheight = l:org_cmdheight
	"             call l:winheights.restore()
	"         endif
	"     endfunction
	"     return l:callback
	" endif

	" if l:cmdheight_changed
	"     let &cmdheight = l:org_cmdheight
	"     call l:winheights.restore()
	" endif
endfunction
