function! edit#base#Append(str) range
	for l:ln in range(a:firstline, a:lastline)
		let l:lineStr = getline(l:ln)
		if l:lineStr =~ a:str . '$'
			continue
		endif
		call setline(l:ln, l:lineStr . a:str)
	endfor
endfunction

function! edit#base#ToggleTrailing(str)
	let l:lineStr = getline('.')
	if l:lineStr =~ a:str . '$'
		call setline('.', l:lineStr[:-(strlen(a:str) + 1)])
		return
	endif
	call setline('.', l:lineStr . a:str)
endfunction
