" {{{ || options || ---

" << system >>
set encoding=utf-8
set fileencodings^=utf-8
if has('unix')
  set shell=/bin/bash
endif

" << looks and feel >>
set background=dark           " color scheme for dark background
set number " relativenumber       " show line number and distance relative to current line
set cursorline            " current line is underlined
set nomodeline              " modeline brings security issue?
set wrap                    " whether to wrap long lines
set scrolloff=5 sidescrolloff=1     " offset between cursor and the edge of window"
set sidescroll=1            " scroll minimal when cursor goes off the screen horizontally
if has('gui')
  set title
  set titlestring=%{getcwd()}       " current directory
  set titlestring+=\ \|\ %F%a       " full path to the file and argument list info
  if !empty(v:servername)
    set titlestring+=\ \|\ %{v:servername}  " server name such as 'VIM'
  endif
endif
set laststatus=2            " always display status bar
set showtabline=2           " always display tabline
set shortmess+=c
set signcolumn=yes

" << editing >>
set expandtab                           " use whitespaces instead of tab char
set autoindent smartindent              " indentation support
set shiftround                          " round tab width for > and < command
set fileformats=unix,dos,mac            " Prefer Unix over Windows over OSX formats
set listchars=tab:\|\                   " Show unvisible chars
set backspace=indent,eol,start          " Enable backspace to wrap line and delete break
set virtualedit=block                   " Allow cursor to move beyond the EOL when visual-block mode
set iminsert=0 imsearch=-1              " prevent entering Japaneve input mode when entering insert and search mode
set shellslash                          " always use forward slash
set formatoptions+=jmM
set nofixendofline                      " Preserve the current EOL state
set timeoutlen=600
set ttimeoutlen=0                       " This prevents <Esc> to hang in input mode on Linux terminal

" << search >>
set ignorecase              " Do case insensitive matching
set smartcase             " Do smart case matching
set incsearch             " Incremental search
set hlsearch              " highlight the match
set matchpairs+=<:>           " % command jumps between <> as well

" << others >>
set noswapfile
set cpoptions+=Iy           " I:autoindent is not removed when moving to other lines
set whichwrap+=<,>            " allow <Left> and <Right> in move to other lines
set complete+=k             " ins-completion option (include dictionary search)
set completeopt=longest,menuone,preview " ins-completion mothod (complete to longest, display menu even though only one match)
set splitbelow splitright       " splitted windows goes to below or right
set showcmd               " Show (partial) command in status line.
set lazyredraw              " screen will not be redrawn till macro execution is done
set diffopt+=vertical
set sessionoptions=blank,curdir,folds,tabpages,winsize

" << command mode >>
set history=1000
set wildignorecase            " command mode completion ignores case
set wildignore+=*.swp,*.bak,*.class   " ignore files this specified extentions on completion
set wildmenu              " display menu on command line completion
set wildcharm=<Tab>           " This enables cycling through popup version of wildmenu with <expr> keymap
set wildmode=full,longest:full      " command mode completion method
" --- || options || }}}

" {{{ || autocmd || ---
" augroup prevents duplicated effect by disabling previous effect of the same group
if has("autocmd")
  augroup buffer_init
    autocmd!
    " jump to the last position when reopening a file
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
  augroup END

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

  augroup misc
    autocmd!
    " fix windows size on resizing vim
    autocmd VimResized * :wincmd =
    " disable relativenumber in quickfix window
    autocmd FileType qf setlocal norelativenumber
    " paired with completeopt=preview
    autocmd CompleteDone * pclose
  augroup END
endif
" --- || autocmd || }}}

" {{{ || key mapping || ---

" {{{ || Leader || ---
noremap <Space> <Nop>
sunmap <Space>
let mapleader = "\<Space>"
let maplocalleader = "-"

" Use local leader for ftplugins
" let maplocalleader = "\<C-Space>"

let g:vert_key = "\<C-Space>"
map <C-Space> [Vert]

map ; [Chief]
let g:chief_key = ';'
if has('xterm_clipboard')
  nnoremap [Chief] "+
  xnoremap [Chief] "+
else
  nnoremap [Chief] "*
  xnoremap [Chief] "*
endif
" --- || Leader || }}}

" {{{ || cursor motion || ---
noremap j gj
noremap k gk
onoremap j Vj
onoremap k Vk
" J & K below is to prevent accidental line join and opening help
xnoremap J j
xnoremap K k
sunmap j
sunmap k
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
map H <Home>
sunmap H
nnoremap L $
onoremap L $
xnoremap L g_

snoremap <C-f> <Right>
snoremap <C-b> <Left>
snoremap <C-p> <Up>
snoremap <C-n> <Down>
snoremap <M-f> <S-Right>
snoremap <M-b> <S-Left>
snoremap <M-p> <S-Up>
snoremap <M-n> <S-Down>
snoremap <C-i> <ESC>i

" {{{ || insert/command mode || ---
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap <M-f> <C-Right>
inoremap <M-b> <C-Left>
inoremap <M-e> <Esc>ea
inoremap <M-E> <Esc>Ea
inoremap <M-e> <Esc>ea
inoremap <M-E> <Esc>Ea
inoremap <expr> <silent> <C-a> col('.') == match(getline('.'),'\S')+1 ? "\<C-o>0" : "\<C-o>^"
inoremap <expr> <C-e> pumvisible() ? "\<C-e>" : "\<End>"
inoremap <C-p> <Up>
inoremap <C-n> <Down>
" --- || insert/command mode || }}}

" [always search forward/backword]
" noremap <expr> <Bslash> getcharsearch().forward ? ';' : ','
" noremap <expr> <Bar> getcharsearch().forward ? ',' : ';'
" XXX these do not work if the cursor is on the last element
" as in /cursor/is/he|re
onoremap <silent> ad :call SelectPair('${', '', '}', 1)<CR>
xnoremap <silent> ad :<C-u>call SelectPair('${', '', '}', 1)<CR>
xnoremap <silent> i/ T/ot/
onoremap <silent> i/ :normal! T/vt/<CR>
xnoremap <silent> a/ T/of/
onoremap <silent> a/ :normal! T/vf/<CR>
function! VisualOperator(operatortype)
  if a:operatortype ==# 'v'
    normal! `<v`>
  else
    normal! `[v`]
  endif
endfunction
" --- || cursor motion || }}}

" {{{ || scrolling || ---
noremap <C-u> 10<C-y>
noremap <C-d> 10<C-e>
noremap <M-y> zh
noremap <M-e> zl
noremap <M-Y> zH
noremap <M-E> zL
" --- || scrolling || }}}

" {{{ || editing || ---
nnoremap <M-x> "_x
nnoremap <M-X> "_X
snoremap <C-h> <Space><BS>
" [insert/command mode]
noremap! <C-Space> <Space><Left>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-u> <C-g>u<C-u>
inoremap <C-y> <C-g>u<C-r>"
cnoremap <C-y> <C-r>"
noremap! <M-y> <C-r>*
inoremap <C-d> <DEL>
inoremap <M-d> <C-g>u<C-\><C-o>"_dw
inoremap <C-k> <C-g>u<C-\><C-o>"_D
inoremap <M-h> <C-g>u<C-w>
cnoremap <M-h> <C-w>
inoremap <M-t> <C-d>
inoremap <C-j> <CR><Esc><Up>A
" [UPPER/lowercase & Capitalize]
inoremap <M-u> <Esc>gUiwea
inoremap <M-l> <Esc>guiwea
inoremap <M-c> <Esc>guiwgU<right>ea
" [Line break/join]
nnoremap <M-m> mpo<Esc>0Dg`p| "insert blank line below
nnoremap <M-M> mpO<Esc>0Dg`p| "insert blank line above
nnoremap <M-o> o<Esc>
nnoremap <M-O> O<Esc>
nnoremap <C-j> i<CR><Esc><Up><End>
" [Other editing]
xnoremap y ygv<Esc>|  "place cursor after the selection when yanking
nnoremap Y y$
nnoremap yx yVaB%p
xnoremap <silent> <C-a> <C-a>gv
xnoremap <silent> <C-x> <C-x>gv
nnoremap <silent> g<C-a> :call search("[0-9]", 'be', line('.'))<CR><C-a>
nnoremap <silent> g<C-x> :call search("[0-9]", 'be', line('.'))<CR><C-x>
nnoremap d. /\s\+$<CR>"_dgn|  " delete trailing spaces
nnoremap U <Nop>
inoremap <C-_> <C-o>u
inoremap <C-/> <C-o>u
inoremap <M-/> <C-o><C-r>
" [set undo break before commands below]
inoremap <Space> <C-g>u<Space>
inoremap <C-m> <C-g>u<C-m>
inoremap . .<C-g>u
" --- || editing || }}}

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
if exists('v:hlsearch')
  nnoremap <silent> <expr> <M-u> (&hlsearch && v:hlsearch ? ':nohlsearch<CR>' : ':set hlsearch<CR>')
else
  nnoremap <silent> <M-u> :set hlsearch! hlsearch?<CR>
endif
" --- || Search || }}}

" {{{ || Buffer || ---
command! BufOnly %bdelete | edit#
" --- || Buffer || }}}

" {{{ || Window || ---
nnoremap <silent> <C-w>O :only!<CR>
nnoremap <C-w>B :bdelete<CR>
" --- || Window || }}}

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
if has('autocmd')
  let g:lasttabnum = 1
  augroup last_tab
    autocmd!
    autocmd TabLeave * let g:lasttabnum = tabpagenr()
  augroup END
  command! LastTab execute "tabnext " . g:lasttabnum
  nnoremap <silent> <C-t><C-t> <Cmd>LastTab<CR>
endif
" --- || Tab || }}}

" {{{ || Suspend/Close/Exit || ---
nnoremap ZB :bdelete!<CR>
nnoremap ZT :windo quit!<CR>
nnoremap <C-w><C-a> :windo confirm quit<CR>
nnoremap <C-w>A :confirm qall<CR>
" --- || Suspend/Close/Exit || }}}

" {{{ || Others || ---
map <S-Space> <Space>
nnoremap <C-s> :update<CR>
nnoremap Q gQ
nnoremap <M-c> <Cmd>mode<CR>
" [insert/command mode]
cnoremap <M-p> <Up>
cnoremap <M-n> <Down>
cnoremap <M-@> <Home>let @" = '<End>'
" --- || Others || }}}

" --- || key mapping || }}}

" {{{ || abbreviation || ---
cnoreabbrev ehco echo
cnoreabbrev tn tabnew
cnoreabbrev tm TabnewMulti
cnoreabbrev ts tab split
cnoreabbrev vb vertical sbuffer
cnoreabbrev tb tab sbuffer
cnoreabbrev th tab help
" --- || abbreviation || }}}

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

" Get ftplugins (including after) for the specified file type and return them as a list
function! GetFtplugins(filetype)
  let l:files = []
  let l:basedir = expand('~/toybox/vim/rtp/')
  let l:trailing_path = 'ftplugin/' . a:filetype . '.vim'
  let l:ftppath = l:basedir . l:trailing_path
  let l:aftppath = l:basedir . 'after/' . l:trailing_path

  if filereadable(l:ftppath)
    call add(l:files, l:ftppath)
  endif
  if filereadable(l:aftppath)
    call add(l:files, l:aftppath)
  endif

  return l:files
endfunction

" Open ftplugin (including after) for the specified file type
function! OpenFtplugins(...)
  let l:files = []
  for l:ft in a:000
    let l:files += GetFtplugins(l:ft)
  endfor

  if empty(l:files)
    redraw
    echo 'No ftplugins found'
    return
  endif

  for l:file in l:files
    silent execute 'tabnew '.l:file
  endfor
endfunction
command! -nargs=+ -complete=filetype OpenFtplugins :call OpenFtplugins(<f-args>)

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
"
source ~/toybox/nvim/init.lua
