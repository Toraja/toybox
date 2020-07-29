function! edit#semicolon#Append() range
	for l:ln in range(a:firstline, a:lastline)
		let l:lineStr = getline(l:ln)
		if l:lineStr =~ ';$'
			continue
		endif
		call setline(l:ln, l:lineStr . ';')
	endfor
endfunction
