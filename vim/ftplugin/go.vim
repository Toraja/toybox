" {{{ || vim-go || ---
if exists('g:plugs["vim-go"]')
	let g:go_doc_keywordprg_enabled = 0     " disable K to open GoDoc
	" let g:go_autodetect_gopath = 1
	let g:go_list_type = "locationlist"
	let g:go_def_mapping_enabled = 0		" prevent <C-t> from being mapped
	let g:go_def_reuse_buffer = 0			" even when disabled, it goes to already opend window/tab
	if !exists('g:go_auto_type_info')		" do not override when it is disabled manually
		let g:go_auto_type_info = 1			" Display method signature
	endif
	" let g:go_auto_sameids = 1				" highlight same variable, package etc

	" These highlight might hinder vim's performance
	" let g:go_highlight_types = 1				" does not look good on desert colorscheme (too much yellow)
	let g:go_highlight_fields = 1
	let g:go_highlight_functions = 1
	let g:go_highlight_function_calls = 1
	highlight link goFunctionCall Function
	" let g:go_highlight_function_arguments = 1
	" let g:go_highlight_format_strings = 0		" enabled by default
	" let g:go_highlight_variable_declarations = 1
	" let g:go_highlight_variable_assignments = 1
	" let g:go_highlight_operators = 1
	let g:go_highlight_extra_types = 1
	" let g:go_highlight_build_constraints = 1	" highlight comment like // +build linux
	" let g:go_highlight_generate_tags = 1		" highlight comment like // go:generate

	let g:go_term_enabled = 1
	let g:go_term_mode = "vsplit"

	let g:go_fmt_command = "goimports"	" 'goimports' does format code as well
	let g:go_fmt_options = {
				\ 'gofmt': '-s',
				\ 'goimports': '',
				\ }
	let g:go_metalinter_autosave = 1
	let g:go_metalinter_deadline = "10s"
endif
" --- || vim-go || }}}

" {{{ || deoplete-go || ---
if exists('g:plugs["deoplete-go"]')
	if &showmode
		setlocal cmdheight=2		" you can see the mode as well as parameter hint
	endif
	if has('win32') || has('win64')
		let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode.exe'
	else
		let g:deoplete#sources#go#gocode_binary = $GOPATH.'/bin/gocode'
	endif
	let g:deoplete#sources#go#sort_class = ['package', 'func', 'type', 'var', 'const']
endif
" --- || deoplete-go || }}}
