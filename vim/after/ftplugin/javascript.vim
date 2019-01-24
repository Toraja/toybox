setlocal expandtab
setlocal shiftwidth=2

" {{{ || Syntastic || ---
if exists('g:plugs["syntastic"]')
	let g:syntastic_javascript_checkers = ['eslint']
	let g:syntastic_javascript_eslint_exe = 'node ./node_modules/eslint/bin/eslint.js - %'
endif
" --- || Syntastic || }}}

" {{{ || Tern || ---
if exists('g:plugs["tern_for_vim"]')
	let g:tern_show_argument_hints = "on_move"
	let g:tern_show_signature_in_pum = 1
	setlocal omnifunc=tern#Complete
	" TODO read about TernDef (and alikes) and use below
	" autocmd FileType javascript nnoremap <silent> <buffer> gd :TernDef<CR>
endif
" --- || Tern || }}}

" {{{ || deoplete || ---
" call deoplete#custom#source('omni', 'input_patterns', {
"             \ 'javascript': ''
"             \})
" call deoplete#custom#source('omni', 'functions', {
"             \ 'javascript': 'tern#Complete'
"             \})
" call deoplete#custom#option({
"             \ 'complete_method': 'omnifunc',
"             \})
" --- || deoplete || }}}

nnoremap <buffer> <M-;> m'A;<Esc>`'
inoremap <buffer> <M-;> <End>;

"if
inoreabbrev <buffer> if if(){<CR>}<Up><C-o>f)
inoreabbrev <buffer> ife if(){<CR>}<CR>else{<CR>}<Esc>3<Up>f)i
inoreabbrev <buffer> ifee if(){<CR>}<CR>else if(){<CR>}<CR>else{<CR>}<Esc>5<Up>f)i
inoreabbrev <buffer> el else{<CR>}<Esc>O
inoreabbrev <buffer> elif else if(){<CR>}<Up><C-o>f)
"switch
inoreabbrev <buffer> sw switch(){<CR>}<Esc>Ocase 1:<CR>break;<Esc><Up>2yy<Down>2gpOdefault:<CR>break;<Esc>8<Up>F)i
"for
inoreabbrev <buffer> for for(i = 0; i < ; i++){<CR>}<Up><C-o>f<<Right><Right>
inoreabbrev <buffer> fori for(let  in ){<CR>}<Up><C-o>ft<Right><Right>
inoreabbrev <buffer> foro for(let  of ){<CR>}<Up><C-o>ft<Right><Right>
"while
inoreabbrev <buffer> wh while(){<CR>}<Up><C-o>f)
inoreabbrev <buffer> do do{<CR>}while();<Left><Left>
"try/catch
inoreabbrev <buffer> try try{<CR><Up><Down><CR>}<CR>catch(err){<CR><Up><Down><CR>}<Esc>4<Up>A
inoreabbrev <buffer> tryf try{<CR><Up><Down><CR>}<CR>catch(err){<CR><Up><Down><CR>}<CR>finally{<CR><Up><Down><CR>}<Esc>7<Up>A
"function
inoreabbrev <buffer> fun function(){<CR>}<Up><End><C-o>F)
inoreabbrev <buffer> funr function(req, res){<CR>}<Esc>O
inoreabbrev <buffer> funrn function(req, res, next){<CR>}<Esc>O
" inoreabbrev <buffer> => () => {<CR>}<Up><End><C-o>F)
inoreabbrev <buffer> lam () => {<CR>}<Up><End><C-o>F)
inoreabbrev <buffer> lamr (req, res) => {<CR>}<Esc>O
inoreabbrev <buffer> lamrn (req, res, next) => {<CR>}<Esc>O
" other
inoreabbrev <buffer> pro new Promise((resolve, reject) => {<CR>})<Esc>O

"syntax
" syn region  javaScriptStringB			start=+`+  skip=+\\\\\|\\`+  end=+`\|$+	contains=javaScriptSpecial,@htmlPreproc
" hi def link javaScriptStringB			String
