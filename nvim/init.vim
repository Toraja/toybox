" This must come before loading my vimrc or nvim fails to load plugins
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/toybox/vim/vimrc
