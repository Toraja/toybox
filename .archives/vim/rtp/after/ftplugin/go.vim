setlocal shiftwidth=4 tabstop=4

" {{{ || vim-go || ---
" Workaround to use script local variable in keymap
function! s:InitGocmds()
	let l:go_import_args = runcmds#init#MakeCmdArgsList([['expand("<cword>")', v:true]])
	let l:switch_term_mode_args = runcmds#init#MakeCmdArgsList([['"current mode ='], ['g:go_term_mode', v:true]])
	let l:go_run_args = runcmds#init#MakeCmdArgsList([['%']])
	let l:go_test_func_new_tab_focus_args = runcmds#init#MakeCmdArgsList([['-v']])
	let l:go_test_file_args = runcmds#init#MakeCmdArgsList([['-v']])
	let l:go_cmds = {
				\ 'a': runcmds#init#MakeCmdInfo('GoAlternateVSplit!', v:false),
				\ 'B': runcmds#init#MakeCmdInfo('!go test -bench .'),
				\ 'c': runcmds#init#MakeCmdInfo('GoCallers'),
				\ 'C': runcmds#init#MakeCmdInfo('GoCallees'),
				\ 'D': runcmds#init#MakeCmdInfo('GoDescribe'),
				\ 'e': runcmds#init#MakeCmdInfo('GoErrCheck', v:true),
				\ 'F': runcmds#init#MakeCmdInfo('GoFmtAutoSaveToggle'),
				\ 'g': runcmds#init#MakeCmdInfo('GoDebugBreakpoint'),
				\ 'G': runcmds#init#MakeCmdInfo('GoDebugTestFuncNewTab'),
				\ 'h': runcmds#init#MakeCmdInfo('GoSameIds'),
				\ 'H': runcmds#init#MakeCmdInfo('GoSameIdsClear'),
				\ 'i': runcmds#init#MakeCmdInfo('GoInfo'),
				\ 'I': runcmds#init#MakeCmdInfo('GoAutoTypeInfoToggle'),
				\ 'k': runcmds#init#MakeCmdInfo('GoCallstack'),
				\ 'l': runcmds#init#MakeCmdInfo('GoMetaLinter', v:true),
				\ 'L': runcmds#init#MakeCmdInfo('GoMetaLinterAutoSaveToggle'),
				\ 'm': runcmds#init#MakeCmdInfo('GoImplements'),
				\ 'M': runcmds#init#MakeCmdInfo('GoImport', v:true, l:go_import_args),
				\ 'o': runcmds#init#MakeCmdInfo('GoDecls'),
				\ 'O': runcmds#init#MakeCmdInfo('GoDeclsDir'),
				\ 'p': runcmds#init#MakeCmdInfo('GoChannelPeers'),
				\ 'r': runcmds#init#MakeCmdInfo('GoRun', v:true, l:go_run_args),
				\ 's': runcmds#init#MakeCmdInfo('GoFillStruct'),
				\ 'S': runcmds#init#MakeCmdInfo('GoAddTags'),
				\ 't': runcmds#init#MakeCmdInfo('GoTestFuncNewTabFocus', v:false, l:go_test_func_new_tab_focus_args),
				\ 'T': runcmds#init#MakeCmdInfo('GoTestFile', v:false, l:go_test_file_args),
				\ '': runcmds#init#MakeCmdInfo('GoTestRecursive', v:false),
				\ 'v': runcmds#init#MakeCmdInfo('GoCoverage', v:true),
				\ 'V': runcmds#init#MakeCmdInfo('GoCoverageClear', v:true),
				\ 'w': runcmds#init#MakeCmdInfo('GoWhicherrs'),
				\ 'W': runcmds#init#MakeCmdInfo('SwitchTermMode', v:false, l:switch_term_mode_args),
				\ }
				" \ 'd': runcmds#init#MakeCmdInfo('GoDoc'),
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
command! -buffer -bang -nargs=* GoTestRecursive RunInNewTabTerminal! go test ./... <q-args>

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

nmap <buffer> [t <Plug>(go-def-pop)
nmap <buffer> ]t <Plug>(go-def-stack)
lua << EOF
  local wk = require("which-key")
  wk.register({
		-- go-def-xxx does not open window/tab if the destination is on the same file
		["<C-]>"] = { "<Plug>(go-def)", "Definition" },
		["<C-w><C-]>"] = { "<C-w>s<Plug>(go-def)", "Definition [horz]"  },
		["[Vert]<C-]>"] = { "<C-w>v<Plug>(go-def)", "Definition [vert]" },
		["<C-t><C-]>"] = { "<Cmd>tab split<CR><Plug>(go-def)", "Definition [tab]" },
  }, { noremap=false, buffer=0 })
EOF

cnoreabbrev gbl GoBuild
cnoreabbrev gcv GoCoverage
cnoreabbrev gfm GoFmt
cnoreabbrev ggs GoGuruScope
cnoreabbrev gim GoImport
cnoreabbrev gima GoImportAs
cnoreabbrev gims GoImports
cnoreabbrev gml GoMetaLinter
cnoreabbrev gmlt GoMetaLinterAutoSaveToggle

" --- || vim-go || }}}
