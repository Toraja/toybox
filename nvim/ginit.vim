source ~/toybox/vim/gvimrc

" XXX nvim-qt doesn't take '-p' option so it won't open multiple files as tabs
" This is workaround
function! OptionP()
	tab ball
	if argc() > 0
		tabnext 1
		if bufname('%') == ""
			quit
		endif
	endif
endfunction
" autocmd VimEnter for this does not work as intended
if !exists('g:loaded_ginit_vim')
	call OptionP()
endif

" As has('gui') is not true on nvim-qt, override the mapping
let $MYGVIMRC = fnamemodify($MYVIMRC, ':p:h').'/ginit.vim'
nnoremap <F3> :source $MYVIMRC<CR>:source $MYGVIMRC<CR>

GuiTabline 0
GuiPopupmenu 0
call GuiClipboard()
call GuiWindowMaximized(1)

let g:loaded_ginit_vim = 1
