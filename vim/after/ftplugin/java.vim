setlocal matchpairs+==:;

" {{{ || keymap || ---
" append semi-colon at the end of line
nnoremap <M-;> A;<Esc>
inoremap <M-;> <End>;
nnoremap <M-:> A;<CR><Esc>
inoremap <M-:> <End>;<CR>
" --- || keymap || }}}

" compile and run
" nnoremap <buffer> <F7> :call Compile()<CR>
if has('win32')
	" FIXME error is not displayed properly on quickfix window...
	" Probably an encoding issue
	setlocal shellpipe=2>
	" setlocal errorformat=%A%f:%l:\ %m,%C%m
endif
setlocal makeprg=javac\ -classpath\ %:p:h\ %
nnoremap <buffer> <F7> :silent lmake \| botright lwindow \| redraw!<CR>
nnoremap <buffer> <F8> :call Run()<CR>

" compile the currently editing file and output between separators
" without specifying 'classpath' for javac, it cannot find symbol
" when the java source references external class
function! Compile()
	" let l:basename = expand('%:t')
	let l:fullpath = expand('%:p')
	" let l:fulldirname = l:fullpath[:(stridx(l:fullpath, l:basename)-2)]
	let l:fulldirname = expand('%:p:h')
	let l:javaccmd = "javac -classpath " . l:fulldirname . " %"
	let l:separatorBgn = "*** Compiling ".l:fullpath." ***"
	let l:separatorEnd = repeat('*', strlen(l:separatorBgn))
	let l:cmd = "!echo ''; echo '".l:separatorBgn."'; ".l:javaccmd."; echo '".l:separatorEnd."'"
	execute l:cmd
endfunction

" run the currently editing file and output between separators
" if no class file is found, prompt the user to compile
function! Run(...)
	" let l:basename = expand('%:t')
	let l:fullpath = expand('%:p')
	let l:simplename = expand('%:t:r')
	" let l:fulldirname = l:fullpath[:(stridx(l:fullpath, l:basename)-2)]
	let l:fulldirname = expand('%:p:h')
	let l:fullpath_wo_ext = l:fullpath[:(stridx(l:fullpath, ".java")-1)]
	let l:classfilepath = l:fullpath_wo_ext . '.class'
	if !filereadable(l:classfilepath)
		echohl Error | echo 'Class file does not exist. ' | echohl None
		if input('Would you like to commpile and run? [y/n] >>> ') == 'y'
			" :call Compile()
			silent lmake | botright lwindow | redraw! | wincmd p
		else
			return
		endif
	endif

	let l:orgwinnr = winnr()
	let l:javacmd = "java -classpath " . l:fulldirname . " " . l:simplename . " " . join(a:000, ' ')
	let l:cmd = "lgetexpr system('".l:javacmd."')"
	execute l:cmd
	" run lopen only when there is some output in location list
	if len(getloclist(l:orgwinnr)) > 0
		lopen
		" bring focus back to the original window
		execute l:orgwinnr . " wincmd w"
	endif
	echohl Comment | echo "Execution completed" | echohl NONE
endfunction

command! -buffer -nargs=* Run :call Run(<f-args>)
command! -buffer Compile :call Compile()

cnoreabbrev cl JCclassNew
cnoreabbrev clf JCclassInFile

function! s:InitCmds()
	let l:cmds = DefaultCmds()
	" let l:cmds['r'] = runcmds#init#MakeCmdInfo('Run')
	let l:cmds.a = runcmds#init#MakeCmdInfo('JCgenerateAbstractMethods')
	let l:cmds.c = runcmds#init#MakeCmdInfo('JCgenerateConstructor')
	let l:cmds.C = runcmds#init#MakeCmdInfo('JCgenerateConstructorDefault')
	let l:cmds.e = runcmds#init#MakeCmdInfo('JCgenerateEqualsAndHashCode')
	let l:cmds.g = runcmds#init#MakeCmdInfo('JCgenerateAccessorGetter')
	let l:cmds.i = runcmds#init#MakeCmdInfo('JCimportAdd')
	let l:cmds.s = runcmds#init#MakeCmdInfo('JCgenerateAccessorSetter')
	let l:cmds.S = runcmds#init#MakeCmdInfo('JCgenerateToString')
	let l:cmds.w = runcmds#init#MakeCmdInfo('JCgenerateAccessorSetterGetter')
	let l:cmds.x = runcmds#init#MakeCmdInfo('JCgenerateAccessors')
	function! s:GetCmds() closure
		return l:cmds
	endfunction
endfunction
call s:InitCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('Run Cmds', <SID>GetCmds())
