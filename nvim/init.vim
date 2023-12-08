" {{{ || options || ---

" << system >>
set nocompatible            " do not use legacy mode
set encoding=utf-8
set fileencodings^=utf-8
if has('unix')
  set shell=/bin/bash
endif

" << looks and feel >>
set background=dark           " color scheme for dark background
if v:version >= 800           " suppress bell sound and flushing
  set belloff=all
else
  set visualbell t_vb=
endif
set t_Co=256              " enrich color
set number " relativenumber       " show line number and distance relative to current line
if !&diff && (has('gui') || has('unix') || has('nvim'))
  set cursorline            " current line is underlined
endif
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

" {{{ || Compose tabline || ---
function! MyTabLine()
  let l:max_fname_length = 20
  let l:tabs = []
  for l:cnt in range(tabpagenr('$'))
    let l:tabpagecnt = l:cnt + 1
    let l:buflist = tabpagebuflist(l:tabpagecnt)

    " select the highlighting
    if l:tabpagecnt == tabpagenr()
      let l:highlight = '%#TabLineSel#'
    else
      let l:highlight = '%#TabLine#'
    endif

    " Add '+' if one of the buffers in the tab page is modified
    let modified = ''
    for l:bufnr in l:buflist
      if getbufvar(l:bufnr, "&modified")
        let l:modified .= '+'
        break
      endif
    endfor

    " Add window number if more than 1 is opened
    " let l:wincnt = tabpagewinnr(l:tabpagecnt, '$')
    " if l:wincnt > 1
    "   let l:tabtitle .= ':' . l:wincnt
    " endif

    " Add file name
    let l:winnr = tabpagewinnr(l:tabpagecnt)
    let l:curbufnr = l:buflist[l:winnr - 1]
    let l:filepath= bufname(l:curbufnr)
    let l:fnamelen = strlen(l:filepath)
    if l:fnamelen == 0
      if getbufvar(l:curbufnr, "&filetype") ==# 'qf'
        let win_info_dict = getwininfo(win_getid())[0]
        if get(win_info_dict, 'loclist', 0)
          let l:filename = '[Location]'
        else
          let l:filename = '[Quickfix]'
        endif
      else
        let l:filename = '[No Name]'
      endif
    else
      let l:filename = fnamemodify(l:filepath, ':t')
      let l:fnamelen = strlen(l:filename)
      if l:fnamelen > l:max_fname_length
        let l:filename = l:filename[:l:max_fname_length]
      endif
    endif

    call add(l:tabs, printf('%s %s%s %s ', l:highlight, l:modified, l:tabpagecnt, l:filename))
  endfor

  " fill with TabLineFill after the last tab
  return ' ' . join(l:tabs, '%#TabLine#|') . '%#TabLineFill#'
endfunction

set tabline=%!MyTabLine()
" --- || Compose tabline|| }}}

" reverse the color of unselected tab
" highlight TabLine term=reverse cterm=bold,reverse gui=reverse

" << editing >>
set expandtab                           " change use whitespaces instead of tab char
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
set tags=./tags;,./TAGS;,tags;,TAGS;
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

" {{{ || automatically enter paste mode when pasting || ---
if &term =~ "xterm"
  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle="\e[201~"

  function! XTermPasteBegin(command)
    set paste
    return a:command
  endfunction

  nnoremap <special> <expr> <Esc>[200~ XTermPasteBegin("i")
  " This delays exiting Insert and Command mode by pressing <Esc>
  " inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
  " cnoremap <special> <Esc>[200~ <Nop>
  " cnoremap <special> <Esc>[201~ <Nop>
endif
" --- || automatically enter paste mode when pasting || }}}

" {{{ || enable meta-key bindings || ---
if !get(s:, 'meta_key_bound') && has('unix') && !has('nvim')
  " fix meta-keys which generate <Esc>a .. <Esc>z
  " do this once only so that keymaps defined by plugin will not be overwritten with <Nop>
  let s:set_meta_to_esc = "set <M-%s>=\e%s"
  let s:map_esc_to_meta = "noremap%s \e%s <M-%s>"
  let s:map_meta_to_nop = "noremap%s <M-%s> <Nop>"
  let c = 'a'
  while c <= 'z'
    " lower case
    exec printf(s:set_meta_to_esc, c, c)
    exec printf(s:map_esc_to_meta, '!', c, c)
    exec printf(s:map_esc_to_meta, '', c, c)
    exec printf(s:map_meta_to_nop, '!', c)
    exec printf(s:map_meta_to_nop, '', c)
    " upper case - skip M-O as it is part of del key, ins key, F key and etc
    if c != 'o'
      let C = toupper(c)
      exec printf(s:set_meta_to_esc, C, C)
      exec printf(s:map_esc_to_meta, '!', C, C)
      exec printf(s:map_esc_to_meta, '', C, C)
      exec printf(s:map_meta_to_nop, '!', C)
      exec printf(s:map_meta_to_nop, '', C)
    endif
    let c = nr2char(1+char2nr(c))
  endwhile
  unlet c C

  " meta + special-keys
  " note: '[' cannot be mapped as it's part of some keycodes
  exec "set <M-$>=\e$"
  exec "set <M-#>=\e#"
  exec "set <M-*>=\e*"
  exec "set <M-+>=\e+"
  exec "set <M-->=\e-"
  exec "set <M-/>=\e/"
  exec "set <M-:>=\e:"
  exec "set <M-;>=\e;"
  exec "set <M-=>=\e="
  " exec "set <M-]>=\e]" " This causes vim to work funny
  exec "set <M-_>=\e_"
  exec "set <M-`>=\e`"

  for n in range(0, 9)
    exec "set <M-".n.">=\e".n
    exec "noremap! \e".n." <M-".n.">"
    exec "noremap \e".n." <M-".n.">"
    exec "noremap <M-".n."> <Nop>"
  endfor
  unlet n
endif
let s:meta_key_bound = 1
" --- || enable meta-key bindings || }}}

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

" {{{ || Terminal || ---
tnoremap <nowait> <M-\> <C-\><C-n>
if &shell =~ 'cmd'
  tnoremap <C-p> <Up>
  tnoremap <C-n> <Down>
  tnoremap <C-f> <Right>
  tnoremap <C-b> <Left>
  tnoremap <M-f> <C-Right>
  tnoremap <M-b> <C-Left>
  tnoremap <C-a> <Home>
  tnoremap <C-e> <End>
  tnoremap <C-d> <Del>
  tnoremap <C-u> <Esc>
endif

" --- || Terminal || }}}

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

" {{{ || functions || ---
" https://stackoverflow.com/questions/24027506/get-a-vim-scripts-snr
" Return the <SNR> of a script.
" Args:
"   script_name : (str) The name of a sourced script.
" Return:
"   (int) The <SNR> of the script; if the script isn't found, -1.
func! GetScriptNumber(script_name)
  redir => scriptnames
  silent! scriptnames
  redir END

  for script in split(l:scriptnames, "\n")
    if l:script =~ a:script_name
      return str2nr(split(l:script, ":")[0])
    endif
  endfor

  return -1
endfunc
" --- || functions || }}}

" {{{ || plugin mapping and option || ---

" {{{ || stephpy/vim-php-cs-fixer || ---
let g:php_cs_fixer_enable_default_mapping = 0
" --- || stephpy/vim-php-cs-fixer || }}}

" --- || plugin mapping and option || }}}

" {{{ || abbreviation || ---
cnoreabbrev ehco echo
cnoreabbrev tn tabnew
cnoreabbrev tm TabnewMulti
cnoreabbrev tnro tabnew <Bar> view
cnoreabbrev spro split <Bar> view
cnoreabbrev vsro vsplit <Bar> view
cnoreabbrev ts tab split
cnoreabbrev vb vertical sbuffer
cnoreabbrev tb tab sbuffer
cnoreabbrev vh vertical help <Bar> execute "normal! \<lt>C-w>80\<Bar>"<C-Left><C-Left><C-Left><C-Left><Left>
cnoreabbrev th tab help
cnoreabbrev bold browse oldfiles
cnoreabbrev st new <Bar> terminal
cnoreabbrev vt vnew <Bar> terminal
cnoreabbrev tt tabnew <Bar> terminal
" --- || abbreviation || }}}

" {{{ || functions || ---
" move back cursor before a command is executed
" offset moves down and right n lines/columns to the original position
function! Preserve(command, linoff, coloff)
  let l = line(".") + a:linoff
  let c = col(".") + a:coloff
  echo a:command
  execute a:command
  call cursor(l, c)
endfunction

fun s:RedrawCancel()
  mode
  echo 'Cancelled'
  return 0
endf

" getchar() with Ctrl+C to cancel
" This returns numeric 0 if interrupted, so the value is compared using 'is'
function! GetChar(escape_means_cancel)
  try
    call inputsave()
    let l:char = nr2char(getchar())
    if a:escape_means_cancel && l:char == "\<Esc>"
      return s:RedrawCancel()
    endif
    return l:char
  catch /^Vim:Interrupt$/
    return s:RedrawCancel()
  finally
    call inputrestore()
  endtry
endfunction

" input() with Ctrl+C to cancel
" This returns numeric 0 if interrupted, so the value is compared using 'is'
function! Input(empty_means_cancel, ...)
  let l:opts = {}
  if a:0 > 0
    if type(a:1) == v:t_dict
      let l:opts = a:1
    else
      let l:opts['prompt'] = get(a:000, 0, '')
      let l:opts['default'] = get(a:000, 1, '')
      if a:0 >= 3
        let l:opts['completion'] = a:3
      endif
    endif
  endif
  try
    call inputsave()
    let l:input = input(l:opts)
    if a:empty_means_cancel && l:input is ''
      return s:RedrawCancel()
    endif
    return l:input
  catch /^Vim:Interrupt$/
    return s:RedrawCancel()
  finally
    call inputrestore()
  endtry
endfunction

function! IsCtrlAlpha(char)
  let l:char_num = char2nr(a:char)
  return char2nr("\<C-a>") <= l:char_num && l:char_num <= char2nr("\<C-z>")
endfunction

" @case: 1 for lowercase, 2 for uppercase
function! ConvertCtrlCharToNormal(char, case)
  const [l:lowercase, l:uppercase] = [1, 2]
  const l:deltas = {
        \ l:lowercase: char2nr('a') - char2nr("\<C-a>"),
        \ l:uppercase: char2nr('A') - char2nr("\<C-a>"),
        \}

  let l:char_num = char2nr(a:char)
  if !IsCtrlAlpha(a:char)
    echoerr printf('Invalid argument: %s is not ctrl-{alphabet}', a:char)
    return
  endif

  let l:delta = get(l:deltas, a:case, '')
  if l:delta is ''
    echoerr printf('Invalid argument: case must be either %s', [l:lowercase, l:uppercase])
    return
  endif

  return nr2char(l:char_num + l:delta)
endfunction

function! SelectBtwCols(sln, spos, eln, epos)
  " NOTE: Use cursor() instead of '|' command
  " searchpairpos() reterns 'n' as in nth char rather than column number.
  " '|' goes to column number, so if the line is indented with tab, '|' misbehaves.
  " since tab is single character but takes up &shiftwidth columns
  " execute 'normal! '.l:spos.'|v'.l:epos.'|'
  silent execute printf("normal! :call cursor(%s, %s)\<CR>v:call cursor(%s, %s)\<CR>v`<", a:sln, a:spos, a:eln, a:epos)
endf

function! SelectPair(start, middle, end, include)
  " NOTE: searchpairpos works a little weird as illustrated below
  " With 'c' option, if the cursor is on the first char of 'start' string (with 'b' option, last char of 'end' string),
  " searchpairpos() cannot find the match.
  let [l:sln, l:spos] = searchpairpos(a:start, a:middle, a:end, 'bc')
  let [l:eln, l:epos] = searchpairpos(a:start, a:middle, a:end)
  if l:spos == 0 || l:epos == 0
    " no match was found
    return
  endif
  if !a:include
    let l:spos = l:spos + len(a:start)
    let l:epos = l:epos - len(a:end)
  endif
  call SelectBtwCols(l:sln, l:spos, l:eln, l:epos)
endfunction

" Select either function/method call, object property, or struct (including object itself)
function! SelectElement()
  let l:elemRegexp = '[A-Za-z0-9_.]\+[({]'
  let [l:sln, l:spos] = searchpos(l:elemRegexp, 'bc')
  let [l:eln, l:epos] = searchpos(l:elemRegexp, 'e')
  let l:lastchar = getline(l:eln)[l:epos-1]
  if l:lastchar =~ '[({]'
    let l:start = l:lastchar
    let l:end = ')'
    if l:lastchar == '{'
      let l:end = '}'
    endif
    let [l:eln, l:epos] = searchpairpos(l:start, '', l:end)
  endif
  call SelectBtwCols(l:sln, l:spos, l:eln, l:epos)
endf

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

" Open multiple files each in its own tab
" @... [path[]] Filepath to open. Wildcard is accepted.
function! TabnewMulti(...)
  let l:files = []
  for l:paths in a:000
    for l:node in glob(l:paths, 0, 1)
      " Get absolute path or it fails when the arguments contains
      " recursive wildcard and the expanded result contains files in
      " subdirectory as autocmd changes pwd to the file's containing
      " dirctory and relative path breaks.
      " Also exclude directories.
      if filereadable(l:node)
        call add(l:files, fnamemodify(l:node, ':p'))
      endif
    endfor
  endfor
  let l:filenum = len(l:files)
  if l:filenum == 0
    echohl WarningMsg | echo 'No matching file' | echohl NONE
    return
  endif
  let l:orgtabnr = tabpagenr()
  for l:file in l:files
    execute 'tabnew '.l:file
  endfor
  execute l:orgtabnr.'tabnext'
  " FIXME this message is not displayed
  echo printf('%s file%s opened', l:filenum, l:filenum > 1 ? 's' : '')
endfunction
command! -complete=file -nargs=+ TabnewMulti call TabnewMulti(<f-args>)

function! OutputEditorCmdToPreview(cmd) abort
  let l:org_reg_contents = @@
  redir @">
  try
    silent execute a:cmd
  catch
    echohl ErrorMsg | echo v:exception | echohl NONE
    let @@ = l:org_reg_contents
    return
  finally
    redir END
  endtry

  execute printf('pedit +file\ [%s] %s', escape(a:cmd, ' \'), tempname())
  wincmd P
  %delete _
  put "
  0delete _
  set nomodified

  let @@ = l:org_reg_contents
endfunction
command! -complete=command -nargs=+ OutputEditorCmdToPreview call OutputEditorCmdToPreview(<q-args>)

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

" Solution for restoring window height inside <expr> keymap
" (<expr> does not allow `windo`)
function! SaveWinheight() abort
  let l:winheights = {}
  for i in range(1, winnr('$'))
    let l:winheights[win_getid(i)] = winheight(0)
  endfor

  function! l:winheights.restore() abort
    for i in range(1, winnr('$'))
      execute "resize " . self[win_getid(i)]
    endfor
  endfunction

  return l:winheights
endfunction

" Display dictionary in accending order
function! DispOptions(title, option, message, ...) abort
  let l:SortFunc = get(a:000, 0, '')
  let l:key_name = get(a:000, 1, '')

  echohl Statement | echo a:title | echohl NONE
  for [k,v] in sort(items(a:option), l:SortFunc)
    echo printf('  %s: %s', k, (type(v) == v:t_dict ? v[l:key_name] : v))
  endfor
  unlet k v
  echohl Function | echo a:message | echohl NONE
endf

" Display dictionary in accending order in oneline
function! DispOptionsOneLine(title, option, ...) abort
  let l:SortFunc = get(a:000, 0, '')
  let l:key_name = get(a:000, 1, '')

  echohl Function | echo printf('-- %s -> %s: ', a:title, DictToOneLineString(a:option, ', ', l:SortFunc, l:key_name)) | echohl NONE
endf

function! DictToOneLineString(dict, ...) abort
  let l:separator = get(a:000, 0, ', ')
  let l:SortFunc = get(a:000, 1, '')
  let l:key_name = get(a:000, 2, '')

  let l:output = []
  for [k,v] in sort(items(a:dict), l:SortFunc)
    call add(l:output, printf('%s[%s]', (type(v) == v:t_dict ? v[l:key_name] : v), k))
  endfor
  return join(l:output, l:separator)
endfunction

" Function for sort() to sort 2D list based on the first element of inner array.
" Main usage is to sort list returned by items({dict}).
" Default algorithm of sort() has case insensitive sorting, but it does not
" guarantee that either UPPERCASE or lowercase precedes the other.
" This sort place lowercase before UPPERCASE within the same letter.
function! SortItemsCaseIns(one, two)
  let [l:key1, l:key2] = [a:one[0], a:two[0]]
  if l:key1 ==# l:key2
    return 1
  endif
  if l:key1 ==? l:key2
    " same char but different case -> lowercase should precedes UPPERCASE
    return char2nr(l:key1) > char2nr(l:key2) ? -1 : 1
  endif
  return l:key1 > l:key2 ? 1 : -1
endfunction

" Function for sort() to sort 2D list based on the second element of inner array.
" Main usage is to sort list returned by items({dict}).
" This essentially sort dict by value.
function! SortItemsByValue(one, two)
  return a:one[1] > a:two[1] ? 1 : -1
endfunction

" Like SortItemsByValue() but use nested value
function! SortItemsByNestedValue(key, one, two)
  return a:one[1][a:key] > a:two[1][a:key] ? 1 : -1
endfunction

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

function! RunInNewTabTerminal(shellCmd, focus) abort
  let l:vimCmd = 'tab split term://' . a:shellCmd
  if a:focus
    let l:vimCmd .= ' | startinsert'
  endif
  execute l:vimCmd
endfunction
command! -complete=shellcmd -nargs=+ -bang RunInNewTabTerminal call RunInNewTabTerminal(<q-args>, <bang>0)
" --- || functions || }}}
"
source ~/toybox/nvim/init.lua
