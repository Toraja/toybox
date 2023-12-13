inoreabbrev <buffer> if if [[  ]]; then<CR>fi<Up><C-o>t]
inoreabbrev <buffer> ife if [[  ]]; then<CR>else<CR>fi<Esc>2<Up>t]i
inoreabbrev <buffer> for for  in ; do<CR>done<Up><C-o>ti
inoreabbrev <buffer> wh while [[  ]]; do<CR>done<Up><C-o>t]
inoreabbrev <buffer> wr while read line; do<CR>done <<Space>
inoreabbrev <buffer> wg while getopts : OPT; do<CR>case ${OPT} in<CR>)<CR>;;<CR>)<CR>;;<CR>\?)<CR>exit 2<CR>;;<CR>:)<CR>exit 2<CR>;;<CR>*)<CR>exit 9<CR>esac<CR>done<CR>shift $((OPTIND-1))<CR>unset OPTIND<Esc>17<Up>f:a
inoreabbrev <buffer> case case  in<CR>)<CR>;;<CR>)<CR>;;<CR>*)<CR>esac<Esc>6<Up>tii
inoreabbrev <buffer> sed sed 's///g'<Esc>Tsa
