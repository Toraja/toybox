if filereadable("~/.vim/dict/plantuml.dict")
	setlocal dictionary+=~/.vim/dict/plantuml.dict
endif

if has('unix')
	setlocal makeprg=java\ -jar\ /usr/share/plantuml/plantuml.jar\ %
    nnoremap <buffer> <F7> :silent lmake \| redraw! \| call system('gpicview ' . expand('%:p:r') . ".png &")<CR>
    nnoremap <buffer> <F8> :call system('gpicview ' . expand('%:p:r') . ".png &")<CR>
" E484 Can't open file
elseif has('win32')
	setlocal makeprg=java\ -jar\ C:\Users\Asus\coding\tools\plantuml\plantuml.jar\ %
	nnoremap <buffer> <F7> :silent lmake \| redraw! \| call system(expand('%:p:r') . ".png")<CR>
	nnoremap <buffer> <F8> :call system(expand('%:p:r') . ".png")<CR>
endif

nnoremap <buffer> <M-;> A;<Esc>
inoremap <buffer> <M-;> <End>;

inoreabbrev <buffer> color <color ></color><C-\><C-o>2F>
" inoreabbrev <buffer> color <color ></color><Esc>F>i
inoreabbrev <buffer> note note<CR>end note<Up><End>
inoreabbrev <buffer> notet note top of <CR>end note<Up><End>
inoreabbrev <buffer> noter note right of <CR>end note<Up><End>
inoreabbrev <buffer> notel note left of <CR>end note<Up><End>
inoreabbrev <buffer> noteo note over <CR>end note<Up><End>
inoreabbrev <buffer> cls class {<CR>}<Esc><Up>f{i
inoreabbrev <buffer> acls abstract class {<CR>}<Esc><Up>f{i

