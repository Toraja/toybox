" {{{ || vim-markdown || ---
let g:vim_markdown_new_list_item_indent = 2
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_folding_disabled = 1
" --- || vim-markdown || }}}

" {{{ || vim-surround || ---
let g:surround_{char2nr('i')} = "_\r_"
let g:surround_{char2nr('c')} = "`\r`"
let g:surround_{char2nr('C')} = "```\n\r\n```"
let g:surround_{char2nr('*')} = "**\r**"
let g:surround_{char2nr('b')} = "**\r**"
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
" --- || vim-markdown || }}}
