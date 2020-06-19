let runcmds#init#flag_key_mod = 'mod'
let runcmds#init#flag_key_disp = 'disp'
let runcmds#init#flag_key_bang = 'bang'
let runcmds#init#cmd_info_key_cmd = 'cmd'
let runcmds#init#cmd_info_key_bangable = 'bangable'
let runcmds#init#cmd_info_key_args = 'args'
let runcmds#init#cmd_info_key_always_modify = 'always_modify'

" @cmd [string] command to run
" @1 [string] what to display instead of cmd
" @2 [bool] if false, bang flag will be ignored and command is run without !
" @3 [list] list of dictionary which is {value: [string], eval: [bool]}
" @4 [bool] whether to always modify the command
function! runcmds#init#MakeCmdInfo(cmd, ...) abort
	return {
				\ g:runcmds#init#cmd_info_key_cmd: a:cmd,
				\ g:runcmds#init#cmd_info_key_bangable: get(a:000, 0, v:false),
				\ g:runcmds#init#cmd_info_key_args: get(a:000, 1, []),
				\ g:runcmds#init#cmd_info_key_always_modify: get(a:000, 2, v:false),
				\}
endfunction

"@list_list [2D list] The number of elements in outer list is the number of
" argument passed to a commands. The inner list is:
"			0 [string] value passed to the command
"			1 [bool] whether the value should be eval()ed
function! runcmds#init#MakeCmdArgsList(list_list) abort
	let l:args = []
	for l:arg in a:list_list
		let l:value = l:arg[0]
		let l:eval = len(l:arg) > 1 ? l:arg[1] : v:false
		call add(l:args, {'value': l:value, 'eval': l:eval})
	endfor
	return l:args
endfunction

function! runcmds#init#MakeFlagDict(...)
	let l:dict = {}
	if a:0 >= 1
		let l:dict[g:runcmds#init#flag_key_mod] = a:1
	endif
	if a:0 >= 2
		let l:dict[g:runcmds#init#flag_key_disp] = a:2
	endif
	if a:0 >= 3
		let l:dict[g:runcmds#init#flag_key_bang] = a:3
	endif
	return l:dict
endfunction
