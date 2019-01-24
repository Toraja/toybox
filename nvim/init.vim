" This must come before loading my vimrc or nvim fails to load plugins
set runtimepath^=~/.vim runtimepath+=~/.vim/after
" win32yank issue has been fixed on 0.3.3
" if has('win32') || has('win64')
"     " With this, nvim can use win32yank
"     set runtimepath^=$NvimHome/bin
"     " This is also needed to use win32yank
"     let $PATH = $NvimHome.'\bin;'.$PATH
" endif
let &packpath = &runtimepath

source ~/toybox/vim/vimrc
