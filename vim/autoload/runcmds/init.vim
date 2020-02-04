" @cmd [string] command to run
" @args [list] list of dist which is {value: [string], eval: [bool]}
" @always_modify [bool] whether to always modify the command
" @bangable [bool] if false, bang flag will be ignored and command is run without !
function! runcmds#init#MakeDictInfo(cmd, args, always_modify, bangable) abort
	return {
				\ 'cmd': a:cmd,
				\ 'args': a:args,
				\ 'always_modify': a:always_modify,
				\ 'bangable': a:bangable,
				\}
endfunction

"@list_list [2D list] The number of elements in outer list is the number of
" argument passed to a commands. The inner list is:
"			0 [string] value passed to the command
"			1 [bool] whether the value should be eval()ed
function! runcmds#init#MakeDictInfoArgs(list_list) abort
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
		let l:dict['mod'] = a:1
	endif
	if a:0 >= 2
		let l:dict['disp'] = a:2
	endif
	if a:0 >= 3
		let l:dict['bang'] = a:3
	endif
	return l:dict
endfunction
