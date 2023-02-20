setlocal nosmartindent
" setlocal textwidth=79 " commented out; let Autoformat do the work
setlocal fixendofline " python formatter requires EOL
setlocal makeprg=python\ %

augroup my_python
	autocmd!
	lua preserve_cursor(vim.lsp.buf.format)
augroup end
