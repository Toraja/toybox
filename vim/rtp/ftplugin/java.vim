augroup my_java
	autocmd!
	autocmd BufWritePre *.java call LanguageClient#textDocument_formatting_sync()
augroup end

" {{{ || vim-javacomplete2 || ---
let g:JavaComplete_EnableDefaultMappings = 0
let g:JavaComplete_UsePython3 = 1
let g:JavaComplete_CheckServerVersionAtStartup = 0
" --- || vim-javacomplete2 || }}}
