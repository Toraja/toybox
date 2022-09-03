local lua_format_augroud_id = vim.api.nvim_create_augroup('lua_format', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = lua_format_augroud_id,
  pattern = '*.lua',
  callback = function()
    preserve_cursor(vim.lsp.buf.formatting_sync)
  end,
})
