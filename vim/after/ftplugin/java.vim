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

" <Q-mode>
" g:getter, s:setter, b:both, p:paste from @s and format
nnoremap <buffer> [FTLeader] :call Qmode('n', 0)<CR>
vnoremap <buffer> [FTLeader] :call Qmode('v', 0)<CR>
nnoremap <buffer> <leader>[FTLeader] :call Qmode('n', 1)<CR>
vnoremap <buffer> <leader>[FTLeader] :call Qmode('v', 1)<CR>
function! Qmode(mode, append) range
	echohl Statement
	echo "-- Qmode -> [G]etter, [S]etter, [B]oth, [P]aste"
	echohl NONE
	" redraw updates the screen so that it prevents command/function output becoming multiple line
	" and 'Press ENTER of type command to continue' from popping up
	redraw
	let l:char = nr2char(getchar())
	if l:char == "g" || l:char == "\<C-g>"
		call CreateGetterSetter(a:mode, 'g', a:append)
	elseif l:char == "s" || l:char == "\<C-s>"
		call CreateGetterSetter(a:mode, 's', a:append)
	elseif l:char == "b" || l:char == "\<C-b>"
		call CreateGetterSetter(a:mode, 'b', a:append)
	elseif l:char == "p" || l:char == "\<C-p>"
		let l:startline = line('.')
		put! =g:GetterSetter
		silent execute "normal! =" . l:startline . "gg"
		" clear the command line
		echo
	else
		echohl WarningMsg
		echo 'Not an available option: '.l:char
		echohl NONE
	endif
endfunction

" <getter/setter>
" this function extracts variable type and name on the current line or within the selection,
" creates getter/setter and then save them to register @s
" the count of line in @s will be stored as g:GSetterLineCount
" parameters:
"	mode: [v]isual or [n]ormal
"	method: [g]etter only, [s]etter only and [b]oth
"	append: [0] overwrite the register, [^0] append to the register
function! CreateGetterSetter(mode, method, append)
	" validate argument 'mode' and set start and end line
	if a:mode ==? 'v'
		let l:startLineNum = line("'<")
		let l:endLineNum = line("'>")
	elseif a:mode ==? 'n'
		let l:startLineNum = line(".")
		let l:endLineNum = l:startLineNum
	else
		echohl Error
			echo "Invalid argument: ".a:mode
			echo "1st argument must be either 'n' or 'v'"
		echohl none
		return
	endif

	" validate argument 'method'
	if a:method ==? 'g'
		let l:xettercmd = 'let g:GetterSetter .= Getter(l:type, l:name)'
		let l:msg = 'Getters'
	elseif a:method ==? 's'
		let l:xettercmd = 'let g:GetterSetter .= Setter(l:type, l:name)'
		let l:msg = 'Setters'
	elseif a:method ==? 'b'
		let l:xettercmd = 'let g:GetterSetter .= GSetter(l:type, l:name)'
		let l:msg = 'Getters and Setters'
	else
		echohl Error
			echo "Invalid argument: ".a:method
			echo "1st argument must be either 'g', 's' or 'b'"
		echohl none
		return
	endif

	let l:currentLineNum = l:startLineNum

	" repeat from the start line to the end line
	" clear register unless specified otherwise
	if ! a:append
		let g:GetterSetter = ''
	endif
	while l:currentLineNum <= l:endLineNum
		" let l:tmplist = GetVarTypeName(getline(l:currentLineNum))
		let [l:type, l:name] = GetVarTypeName(getline(l:currentLineNum))
		let l:currentLineNum = l:currentLineNum + 1
		" skip the iteration if type or name is empty
		if !(len(l:type) && len(l:name))
			continue
		endif
		execute l:xettercmd
	endwhile

	echo l:msg." have been created. [FTLeader]C-p to paste it."
endfunction

" extract variable type and name from lines and return those as list as in [type, name]
" if the line is not for declaring variable, returns a list containing 2 empty
function! GetVarTypeName(line)
	" remove leading white spaces
	let l:lineStr = substitute(a:line, '^\s*', '', '')

	" remove all the modifier
	let l:modifierRegexp = '\C^\s*\(public\|protected\|private\|final\|static\|synchronized\|volatile\|transient\)*\s\+'
	while 1
		let l:matchedStr = matchstr(l:lineStr, l:modifierRegexp)
		if len(l:matchedStr) == 0
			break
		" elseif l:matchedStr =~# '\C^\s*static\s\+'
			" let l:isStatic = 1
		endif
		let l:newLineStr = substitute(l:lineStr, l:modifierRegexp, '', '')
		let l:lineStr = l:newLineStr
	endwhile
	" delete trailing characters ()
	let l:newLineStr = substitute(l:lineStr, '\s*\(=.*\)*;.*$', '', '')
	let l:lineStr = l:newLineStr
	" validate whether l:lineStr consists of variable type and name. Skip the line if it does not.
	" type pattern takes Array[][] and Generics<E>/<? extends E> into account (brackets could surrounded with whitespaces)
	" Array that [] is appended to variable name is not supported
	let l:typePtn = '[0-9A-Za-z_]\+\(\s*\(\s*\[\s*\]\)\+\|<\s*[0-9A-Za-z_?,<> ]*\s*>\)*'
	let l:namePtn = '[0-9A-Za-z_]\+'
	if l:lineStr =~# '^'.l:typePtn.'\s\+'.l:namePtn.'$' && l:lineStr !~# '^\s*return'
		let l:typenNameList = [matchstr(l:lineStr, '^'.l:typePtn), matchstr(l:lineStr, l:namePtn.'$')]
	else
		let l:typenNameList = ['', '']
	endif
	return l:typenNameList
endfunction

function! Getter(type, name)
	let l:capitalName = toupper(a:name[0]).a:name[1:]
	return "public ".a:type." get".l:capitalName."(){\nreturn this.".a:name.";\n}\n\n"
endfunction

function! Setter(type, name)
	let l:capitalName = toupper(a:name[0]).a:name[1:]
	return "public void set".l:capitalName."(".a:type." ".a:name."){\nthis.".a:name." = ".a:name.";\n}\n\n"
endfunction

function! GSetter(type, name)
	let l:GSetter = Getter(a:type, a:name) . Setter(a:type, a:name)
	return l:GSetter
endfunction

command! -buffer -nargs=+ Getter :call Getter(<f-args>)
command! -buffer -nargs=+ Setter :call Setter(<f-args>)
command! -buffer -nargs=+ GSetter :call GSetter(<f-args>)
