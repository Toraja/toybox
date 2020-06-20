augroup my_java
	autocmd!
	autocmd BufWrite *.java JCimportsRemoveUnused
	autocmd BufWrite *.java JCimportsAddMissing
	autocmd BufWrite *.java Autoformat
	" somehow this is executed after saving so you need to save twice
	" autocmd BufWritePre *.java call LanguageClient#textDocument_formatting()
augroup end

" {{{ || vim-javacomplete2 || ---
let g:JavaComplete_EnableDefaultMappings = 0
let g:JavaComplete_UsePython3 = 1
let g:JavaComplete_CheckServerVersionAtStartup = 0
" --- || vim-javacomplete2 || }}}
