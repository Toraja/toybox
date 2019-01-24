if has('win32') || has('win64')
	" the path must be to the shell file, not .cmd file. (.cmd file causes error)
	let g:deoplete#sources#ternjs#tern_bin = $NodejsHome.'\tern'
endif
" Whether to include the types of the completions in the result data. Default: 0
let g:deoplete#sources#ternjs#types = 1
" Whether to include documentation strings (if found) in the result data. Default: 0
let g:deoplete#sources#ternjs#docs = 1
" Whether to use a case-insensitive compare between the current word and potential completions. Default: 0
let g:deoplete#sources#ternjs#case_insensitive = 1
" Whether to include JavaScript keywords when completing something that is not a property. Default: 0
let g:deoplete#sources#ternjs#include_keywords = 1
