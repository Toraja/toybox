" This must come before loading my vimrc or nvim fails to load plugins
set runtimepath^=~/toybox/vim/rtp runtimepath+=~/toybox/vim/rtp/after
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

source ~/toybox/vim/vimrc
