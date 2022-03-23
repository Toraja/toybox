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

" {{{ || neomake || ---
" refernce: https://github.com/Phantas0s/.dotfiles/blob/master/nvim/pluggedconf/neomake.nvimrc
" let g:neomake_php_phpcs_args_standard = 'PSR2'
let g:neomake_php_phpcs_args_standard = 'phpcs-laravel' " emielmolenaar/phpcs-laravel
let g:neomake_php_phpstan_args = ['analyse', '--error-format', 'raw', '--no-progress']
let s:phpmd_excludes = 'tests/Feature/,tests/Unit/,database/migrations/'
let g:neomake_php_phpmd_maker = {
            \ 'args': ['%:p', 'text', 'codesize,design,unusedcode,naming', '--exclude', s:phpmd_excludes],
            \ 'errorformat': '%W%f:%l%\s%\s%#%m',
            \ }
" --- || neomake || }}}

inoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
nnoremap <buffer> <silent> <M-;> <Cmd>call edit#base#ToggleTrailing(';')<CR>
vnoremap <buffer> <silent> <M-;> :call edit#base#ToggleTrailing(';')<CR>

command! -buffer Run vsplit | terminal php %

function! s:InitPhpCmds()
  let l:cmds = DefaultCmds()
  let l:cmds.c = runcmds#init#MakeCmdInfo('PhpactorClassNew')
  let l:cmds.c = runcmds#init#MakeCmdInfo('PhpactorCopyFile')
  let l:cmds.f = runcmds#init#MakeCmdInfo('call PhpCsFixerFixFile()')
  let l:cmds.F = runcmds#init#MakeCmdInfo('PhpactorTransform')
  let l:cmds.i = runcmds#init#MakeCmdInfo('PhpactorImportMissingClasses')
  let l:cmds.l = runcmds#init#MakeCmdInfo('NeomakeProject phpstan')
  let l:cmds.m = runcmds#init#MakeCmdInfo('PhpactorMoveFile')
  let l:cmds.M = runcmds#init#MakeCmdInfo('PhpactorContextMenu')
  let l:cmds.r = runcmds#init#MakeCmdInfo('Run')
  let l:cmds.5 = runcmds#init#MakeCmdInfo('!php artisan l5:generate')
  function! s:PhpCmds() closure
    return l:cmds
  endfunction
endfunction
call s:InitPhpCmds()
nnoremap <buffer> <expr> - runcmds#base#RunCmds('PHP Cmds', <SID>PhpCmds())
