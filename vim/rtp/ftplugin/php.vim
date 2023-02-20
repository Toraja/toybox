setlocal expandtab shiftwidth=4

augroup my_php
  autocmd!
  autocmd BufWritePost *.php silent call PhpCsFixerFixFile()
augroup end

" {{{ || vim-php-cs-fixer || ---
let g:php_cs_fixer_enable_default_mapping = 0
" TODO find new solution to get project root dirctory without projectroot plugin
" let g:php_cs_fixer_cache = projectroot#guess() . '/.php_cs.cache'
" let g:php_cs_fixer_config_file = projectroot#guess() . '/.php_cs.dist'
" Unfortunately, plugin gets loaded before ftplugin.
" Unmap the default keybind manually.
silent! nunmap <Leader>pcf
silent! nunmap <Leader>pcd
" --- || vim-php-cs-fixer || }}}

" {{{ || phpactor || ---
" let g:PhpactorRootDirectoryStrategy = function('projectroot#guess')
" --- || phpactor || }}}

inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
xnoremap <buffer> <silent> <M-;> :call edit#base#ToggleTrailing(';')<CR>
