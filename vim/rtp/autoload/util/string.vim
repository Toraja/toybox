function! util#string#IsStrCapitalised(str) abort
	return match(a:str, '\u') == 0
endfunction

function! util#string#Capitalise(str) abort
	return toupper(a:str[0]) . a:str[1:]
endfunction

function! util#string#GetFirstCamelWord(str) abort
	return split(a:str, '\u', v:true)[0]
endfunction

function! util#string#ToUpperFirstCamelWord(str) abort
	if util#string#IsStrCapitalised(a:str)
		return a:str
	endif

	let l:firstCamelWord = util#string#GetFirstCamelWord(a:str)
	let l:firstCamelWordLen = strlen(l:firstCamelWord)
	return toupper(l:firstCamelWord) . a:str[l:firstCamelWordLen:]
endfunction
