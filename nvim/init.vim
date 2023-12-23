" {{{ || autocmd || ---
" augroup prevents duplicated effect by disabling previous effect of the same group
if has("autocmd")
  function! s:PreviousTabStoreState()
    let s:tab_current = tabpagenr()
    let s:tab_last = tabpagenr('$')
  endfunction
  function! s:PreviousTabTabClosed()
    if s:tab_current > 1 && s:tab_current < s:tab_last
      exec 'tabp'
    endif
  endfunction
  augroup prev_tab
    " focus previous tab instead of next tab when closing tab
    autocmd!
    autocmd TabEnter,TabLeave * call s:PreviousTabStoreState()
    autocmd TabClosed * call s:PreviousTabTabClosed()
  augroup end
endif
" --- || autocmd || }}}

" {{{ || key mapping || ---

" {{{ || Search || ---
" open fold which the match belongs to so that you can view where exactly the
" match is.
nnoremap n nzx
nnoremap N Nzx
function! HighlightWord(visual, exclusive, whole_word, case_sesitive) abort
  if a:visual
    let l:word = GetVisualText(v:false)
  else
    let l:word_range = a:whole_word ? '<cWORD>' : '<cword>'
    let l:word = expand(l:word_range)
  endif
  if a:exclusive
    let l:word = '\<' . l:word . '\>'
  endif
  if a:case_sesitive
    let l:word = '\C' . l:word
  endif

  call setreg('/', l:word)
  call histadd('search', l:word)
  " somehow this does not highlight
  " set hlsearch
endfunction
nnoremap <silent> * <Cmd>call HighlightWord(0, 0, 0, 0)<CR><Cmd>set hlsearch<CR>
nnoremap <silent> g* <Cmd>call HighlightWord(0, 1, 0, 0)<CR><Cmd>set hlsearch<CR>
nnoremap <silent> <M-*> <Cmd>call HighlightWord(0, 0, 0, 1)<CR><Cmd>set hlsearch<CR>
nnoremap <silent> g<M-*> <Cmd>call HighlightWord(0, 1, 0, 1)<CR><Cmd>set hlsearch<CR>
nnoremap <silent> <Leader>* <Cmd>call HighlightWord(0, 0, 1, 0)<CR><Cmd>set hlsearch<CR>
xnoremap <silent> * <Esc><Cmd>call HighlightWord(1, 0, 0, 0)<CR><Cmd>set hlsearch<CR>
xnoremap <silent> g* <Esc><Cmd>call HighlightWord(1, 1, 0, 0)<CR><Cmd>set hlsearch<CR>
nnoremap <silent> <expr> <M-u> (&hlsearch && v:hlsearch ? ':nohlsearch<CR>' : ':set hlsearch<CR>')
" --- || Search || }}}

" {{{ || Tab || ---
noremap <C-t> <Nop>
nnoremap <silent> <expr> <C-t><C-n> ":\<C-u>".(v:count ? v:count : "")."tabnew\<CR>"
nnoremap <silent> <expr> <C-t><C-o> ":\<C-u>".(v:count ? v:count : "")."tabonly\<CR>"
nnoremap <silent> <expr> <C-t><C-q> ":\<C-u>".(v:count ? v:count : "")."tabclose\<CR>"
nnoremap <silent> <expr> <C-t><C-d> ":\<C-u>".(v:count ? v:count : "")."tab split\<CR>"
nnoremap <silent> <C-t><CR> <C-w><CR><C-w>T
nnoremap <C-t><C-f> <C-w>gf
nnoremap <C-l> gt
nnoremap <C-h> gT
nnoremap <silent> <expr> <M-l> ":\<C-u>silent! tabmove+".v:count1."<CR>"
nnoremap <silent> <expr> <M-h> ":\<C-u>silent! tabmove-".v:count1."<CR>"
for n in range(1, 9)
  execute printf("nnoremap <M-%s> %sgt", n, n)
endfor
unlet n
nnoremap <M-0> 10gt
" jump to last active tab
let g:lasttabnum = 1
augroup last_tab
  autocmd!
  autocmd TabLeave * let g:lasttabnum = tabpagenr()
augroup END
command! LastTab execute "tabnext " . g:lasttabnum
nnoremap <silent> <C-t><C-t> <Cmd>LastTab<CR>
" --- || Tab || }}}

" --- || key mapping || }}}

" Open files on each line one file in one tab
function! OpenFileOnEachLine() range
  let l:cmd = ""
  for l:linenum in range(a:firstline, a:lastline)
    call cursor(l:linenum, 1)
    let l:path = expand("<cfile>")
    if !filereadable(l:path)
      continue
    endif
    let l:cmd .= "tabnew ".l:path." \<Bar> "
  endfor
  execute l:cmd
endfunction
command! -range=% OpenFileOnEachLine <line1>,<line2>call OpenFileOnEachLine()

function! SetOperatorFunc(funcname)
  execute 'set operatorfunc=' . a:funcname
  echohl Identifier | echon a:funcname | echohl NONE
  echon ' is being called. Enter motion key:'
endfunction

function! GetOperatorText(operatortype, noline)
  if a:operatortype ==# 'v'
    normal! `<v`>y
  elseif a:operatortype ==# 'char'
    normal! `[v`]y
  else
    if a:noline
      echohl WarningMsg
      echo "line-wise motion and line/block-wise selection is not supported"
      echohl NONE
      throw "Exception"
    endif

    normal! `[V`]y
  endif
  return @"
endfunction

function! GetVisualText(stay_in_visual)
  normal! gvy
  let l:result = getreg('"')
  if a:stay_in_visual
    normal! gv
  endif
  return l:result
endfunction

" Set filetype again with the current buffer's file type
function! SetFt(...)
  execute 'set filetype=' . get(a:000, 0, &filetype)
endfunction
command! -nargs=? -complete=filetype SetFt :call SetFt(<f-args>)
cnoreabbrev sf SetFt

" Open diff of 2 files
function! s:diff(...)
  if a:0 != 2
    echoerr 'Diff takes exactly 2 arguments'
    return
  endif

  let l:msgFileNotExists = '%s does not exist'
  if !filereadable(a:1)
    echoerr printf(l:msgFileNotExists, a:1)
    return
  endif
  if !filereadable(a:2)
    echoerr printf(l:msgFileNotExists, a:2)
    return
  endif

  let l:fullpath1 = fnamemodify(a:1, ';p')
  let l:fullpath2 = fnamemodify(a:2, ';p')
  execute 'tabnew '.l:fullpath1
  execute 'diffsplit '.l:fullpath2
endfunction
command! -complete=file -nargs=+ Diff :call s:diff(<f-args>)

" --- || functions || }}}

source ~/toybox/nvim/init.lua
