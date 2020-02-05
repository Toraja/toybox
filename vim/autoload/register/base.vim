function! register#base#CopyRegisterToAnother(reg_from, reg_to) abort
	call setreg(a:reg_to, getreg(a:reg_from))
	echo printf("@%s = %s", a:reg_to, getreg(a:reg_to))
endfunction

function! register#base#CopyRegisterToAnotherInteract()
	registers
	echo 'Register to copy from:'
	let l:reg_from = GetChar(v:true)
	if l:reg_from is 0
		return
	endif
	echo 'Register to save into:'
	let l:reg_to = GetChar(v:true)
	if l:reg_to is 0
		return
	endif

	call register#base#CopyRegisterToAnother(l:reg_from, l:reg_to)
endfunction

function! register#base#EditRegister()
	echo 'Register to edit:'
	" input() converts newline in {default} arguemnt to whitespace.
	" Use <C-r> so that register contents is evaluated after input() is called.
	let l:reg_char = GetChar(v:true)
	if l:reg_char is 0
		return
	endif
	redraw
	let l:contents = Input(v:true, printf("Set register '%s' to:\n", l:reg_char), "\<C-r>". l:reg_char)
	if l:contents is 0
		return
	endif
	call setreg(l:reg_char, l:contents)
endfunction

" clear contents of all char registers
function! register#base#ClearCharRegisters()
	let c='a'
	while c <= 'z'
		execute setreg(c, [])
		let c = nr2char(1+char2nr(c))
	endwhile
endfunction
