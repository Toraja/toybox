function! edit#base#Append(str) range
	for l:ln in range(a:firstline, a:lastline)
		let l:lineStr = getline(l:ln)
		if l:lineStr =~ a:str . '$'
			continue
		endif
		call setline(l:ln, l:lineStr . a:str)
	endfor
endfunction
