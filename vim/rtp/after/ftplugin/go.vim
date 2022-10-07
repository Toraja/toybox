setlocal shiftwidth=4 tabstop=4

function! s:InitGocmds()
	let l:go_cmds = {
				\ 'a': runcmds#init#MakeCmdInfo('GoAltV'),
				\ 'B': runcmds#init#MakeCmdInfo('!go test -bench .'),
				\ 'e': runcmds#init#MakeCmdInfo('GoIfErr'),
				\ 'g': runcmds#init#MakeCmdInfo('GoDebug'),
				\ 'G': runcmds#init#MakeCmdInfo('GoBreakToggle'),
				\ 'h': runcmds#init#MakeCmdInfo('GoChannel'),
				\ 'k': runcmds#init#MakeCmdInfo('GoCallstack'),
				\ 'l': runcmds#init#MakeCmdInfo('GoLint'),
				\ 'r': runcmds#init#MakeCmdInfo('GoRun %'),
				\ 's': runcmds#init#MakeCmdInfo('GoFillStruct'),
				\ 'S': runcmds#init#MakeCmdInfo('GoAddTags'),
				\ 't': runcmds#init#MakeCmdInfo('GoTestFuncNewTabFocus'),
				\ 'T': runcmds#init#MakeCmdInfo('GoTestFile -v'),
				\ '': runcmds#init#MakeCmdInfo('GoAddTest'),
				\ 'v': runcmds#init#MakeCmdInfo('GoCoverage'),
				\ 'V': runcmds#init#MakeCmdInfo('GoCoverage -t'),
				\ '0': runcmds#init#MakeCmdInfo('GoCodeAction'),
				\ '1': runcmds#init#MakeCmdInfo('GoCodeLenAct'),
				\ }
	let l:go_cmds = extend(DefaultCmds(), l:go_cmds)
	function! s:GoCmds() closure
		return l:go_cmds
	endfunction
endfunction
call s:InitGocmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Go Cmds', <SID>GoCmds(), {}, function('SortItemsByNestedValue', [runcmds#init#cmd_info_key_cmd]))
command! -buffer -bang GoAlternateSplit call go#alternate#Switch(<bang>0, 'split')
command! -buffer -bang GoAlternateVSplit call go#alternate#Switch(<bang>0, 'vsplit')
command! -buffer -bang -nargs=* GoDebugTestFunc tab split | GoDebugTestFunc <q-args>
command! -buffer -bang -nargs=* GoTestFile TestFile <q-args>

function! SwitchTermMode()
	let g:go_term_mode = (g:go_term_mode == 'vsplit') ? 'split' : 'vsplit'
	echo 'g:go_term_mode = '.g:go_term_mode
endfunction
command! -buffer -nargs=0 SwitchTermMode call SwitchTermMode()

let s:testifySuiteMethodPattern = 'func ([A-Za-z0-9_]\+ \*\([A-Za-z0-9_]\+\)) \(Test[A-Za-z0-9_]\+\).*'

function! GetNearestTestSuiteMethodLineNum() abort
	return search(s:testifySuiteMethodPattern, "bcnW")
endfunction

let s:testFuncPattern = 'func \(Test\|Example\)'

function! GetNearestTestFuncLineNum() abort
	return search(s:testFuncPattern, "bcnW")
endfunction

function! TestNearestSuiteMethod(args) abort
	" commented out are simple version
	" let l:line = search('func ([A-Za-z0-9_]\+ \*[A-Za-z0-9_]\+) Test', "bcnW")
	let l:line = GetNearestTestSuiteMethodLineNum()
	if l:line == 0
		echohl WarningMsg | echo "No test found immediate to cursor" | echohl NONE
		return
	endif

	let l:decl = getline(l:line)
	" let l:declSplitList = split(l:decl, ' ')
	" let l:type = l:declSplitList[2][1:-2]
	" let l:func = l:declSplitList[3][:-2]
	let l:type = substitute(l:decl, s:testifySuiteMethodPattern, '\1', '')
	let l:func = substitute(l:decl, s:testifySuiteMethodPattern, '\2', '')
	let l:capitalisedType = util#string#Capitalise(l:type)
	let l:upperType = util#string#ToUpperFirstCamelWord(l:type)
	let l:fileDir = expand('%:h')

	let l:cmdTemplate = 'RunInNewTabTerminal! go test ./%s -run Test%s/%s$ %s'
	let l:cmd = printf(l:cmdTemplate, l:fileDir, l:capitalisedType, l:func, a:args)
	if search(s:testFuncPattern . l:capitalisedType . '(', 'bnw') == 0
		let l:cmd = printf(l:cmdTemplate, l:fileDir, l:upperType, l:func, a:args)
		if search(s:testFuncPattern . l:upperType . '(', 'bnw') == 0
			echohl WarningMsg | echo "No test runner found. Try modify the command and execute:" | echohl NONE
			let l:cmd = Input(1, ':', l:cmd)
			call histadd(':', l:cmd)
		endif
	endif

	execute l:cmd
endfunction

function! GoTestFuncNewTabFocus(args) abort
	let l:suiteLineNum = GetNearestTestSuiteMethodLineNum()
	let l:testFuncLineNum = GetNearestTestFuncLineNum()
	let l:closestLineNum = max([l:suiteLineNum, l:testFuncLineNum])
	if l:closestLineNum == 0
		echohl WarningMsg ("No test found immediate to cursor")
	endif

	if l:closestLineNum == l:suiteLineNum
		call TestNearestSuiteMethod(a:args)
	else
		execute 'TestNearest ' . a:args
	endif
endfunction
command! -buffer -nargs=* GoTestFuncNewTabFocus call GoTestFuncNewTabFocus(<q-args>)
