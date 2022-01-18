" {{{ || vim-markdown || ---
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_folding_disabled = 1
" --- || vim-markdown || }}}

" {{{ || vim-surround || ---
let g:surround_{char2nr('i')} = "*\r*"
let g:surround_{char2nr('c')} = "`\r`"
let g:surround_{char2nr('C')} = "```\n\r\n```"
let g:surround_{char2nr('8')} = "**\r**"
let g:surround_{char2nr('~')} = "~~\r~~"
let g:surround_{char2nr('k')} = "~~\r~~"
let g:surround_{char2nr('l')} = "[\r]()"
" --- || vim-surround || }}}

" {{{ || vim-table-mode || ---
" this causes ugly header border
" let g:table_mode_fillchar = ':-:'
let g:table_mode_corner = '|'
let g:table_mode_disable_mappings = 1
let g:table_mode_map_prefix = '<Leader><Bslash>'
" --- || vim-table-mode || }}}

" {{{ || markdown-preview || ---
" let $NVIM_MKDP_LOG_FILE = expand('~/tmp/mkdp.log') " default location is <plugin root>/app/mkdp.log
" let $NVIM_MKDP_LOG_LEVEL = 'debug'
let g:mkdp_auto_close = 0
let g:mkdp_echo_preview_url = 1
let g:mkdp_page_title = '${name}'
if executable('firefox')
	let g:mkdp_browser='firefox'
endif

function! s:MkdpPublish()
	let g:mkdp_open_to_the_world = 1
endfunction
command! MkdpPublish call s:MkdpPublish()

function! s:MkdpUnpublish()
	let g:mkdp_open_to_the_world = 0
endfunction
command! MkdpUnpublish call s:MkdpUnpublish()

function! s:MkdpSetPort(port)
	let g:mkdp_port = a:port
endfunction
command! -nargs=1 MkdpSetPort call s:MkdpSetPort(<q-args>)
" --- || markdown-preview || }}}
