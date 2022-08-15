" {{{ || vim-go || ---
if exists('g:plugs["vim-go"]')
  " let go_debug=['shell-commands'] " output vim-go's actual shell command

  let g:go_doc_keywordprg_enabled = 0     " disable K to open GoDoc
  let g:go_doc_popup_window = 1
  let g:go_jump_to_error = 0
  let g:go_def_mapping_enabled = 0    " prevent <C-t> from being mapped
  let g:go_def_reuse_buffer = 0     " even when disabled, it goes to already opend window/tab
  " if !exists('g:go_auto_type_info')   " do not override when it is disabled manually
  "   let g:go_auto_type_info = 1     " Display method signature
  " endif
  " let g:go_auto_sameids = 1       " highlight same variable, package etc
  let g:go_echo_go_info = 0

  " These highlight might hinder vim's performance
  let g:go_highlight_fields = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_calls = 1
  highlight link goFunctionCall Function
  " let g:go_highlight_build_constraints = 1  " highlight comment like // +build linux
  " let g:go_highlight_generate_tags = 1    " highlight comment like // go:generate

  let g:go_term_enabled = 1
  let g:go_term_mode = "vsplit"

  let g:go_fmt_command = "goimports"  " 'goimports' does format code as well
  let g:go_fmt_options = {
        \ 'gofmt': '-s',
        \ 'goimports': '',
        \ }
  " let g:go_metalinter_command = "golangci-lint"
  let g:go_metalinter_command = "gopls"
  let g:go_gopls_staticcheck = v:true
  let g:go_diagnostics_level = 2 " with this set to 0 (default), staticcheck error will not be displayed
  let g:go_metalinter_autosave = 1
  let g:go_metalinter_deadline = "10s"
  let g:go_metalinter_autosave_enabled = ['vet', 'revive']
  let g:go_metalinter_enabled = ['vet', 'revive', 'errcheck']

  " gopls
  setlocal cmdheight=2 " goinfo by gopls displays comment as well as signature
endif
" --- || vim-go || }}}

" {{{ || vim-test || ---
if exists('g:plugs["vim-test"]')
  if executable('richgo')
    let test#go#runner = 'richgo'
  endif
endif
" --- || vim-test || }}}
