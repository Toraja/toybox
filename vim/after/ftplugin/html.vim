set expandtab shiftwidth=2 tabstop=2

if has('unix')
	nnoremap <buffer> <F8> :!firefox -new-window %<CR>
elseif has('win32')
	nnoremap <buffer> <F8> :call system(expand('%:p'))<CR>
endif

function! InsertTag()
    call inputsave()
	let l:tagname = input('Enter tag name: ')
    call inputrestore()
    execute "normal!a<" . l:tagname . "></" . l:tagname . ">"
endfunction
inoremap <buffer> <C-g><C-t> <Esc>:call InsertTag()<CR>%i
