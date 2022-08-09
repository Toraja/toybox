vim.cmd([[
  augroup lua_format
    autocmd!
    autocmd BufWritePre *.lua silent lua vim.lsp.buf.formatting_sync()
  augroup END
]])
