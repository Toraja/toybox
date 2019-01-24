inoreabbrev <buffer> html <!DOCTYPE html><CR><html><CR><head><CR><title></title><CR></head><CR><body><CR></body><CR></html>

inoreabbrev <buffer> style <style><CR></style><Esc>O
inoreabbrev <buffer> css <link rel="stylesheet" href="" /><Esc>F"i
inoreabbrev <buffer> script <script><CR></script><Esc>O
inoreabbrev <buffer> js <script type="text/javascript" src=""></script><Esc>F"i

inoreabbrev <buffer> a <a href=""></a><Esc>F"i
inoreabbrev <buffer> div <div></div><Esc>F<i
inoreabbrev <buffer> label <label for=""></label><Esc>F"i
inoreabbrev <buffer> span <span></span><Esc>F<i
inoreabbrev <buffer> input <input type="" name="" input=""/><Esc>3T=a
inoreabbrev <buffer> table <table><CR><thead><CR><tr><CR><th></th><CR></tr><CR></thead><CR><tbody><CR><tr><CR><td></td><CR></tr><CR></tbody><CR></table><Esc>F<i
inoreabbrev <buffer> thead <thead><CR><tr><CR><th></th><CR></tr><CR></thead>
inoreabbrev <buffer> tbody <tbody><CR><tr><CR><td></td><CR></tr><CR></tbody>
inoreabbrev <buffer> tfoot <tfoot><CR><tr><CR><td></td><CR></tr><CR></tfoot>
inoreabbrev <buffer> tr <tr><CR></tr><Esc>O
inoreabbrev <buffer> td <td></td><Esc>F<i
inoreabbrev <buffer> form <form action="" method=""><CR></form>
inoreabbrev <buffer> iframe <iframe src=""></iframe><Esc>F"i
inoreabbrev <buffer> dl <dl><CR><C-t><dt></dt><CR><dd></dd><CR><C-d></dl><Up><Up>

if has('unix')
	nnoremap <buffer> <F8> :!firefox -new-window %<CR>
elseif has('win32') || has('win64')
	nnoremap <buffer> <F8> :call system(expand('%:p'))<CR>
endif

function! InsertTag()
    call inputsave()
	let l:tagname = input('Enter tag name: ')
    call inputrestore()
    execute "normal!a<" . l:tagname . "></" . l:tagname . ">"
endfunction
inoremap <buffer> <C-g><C-t> <Esc>:call InsertTag()<CR>%i

