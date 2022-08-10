-- Setting enforced by fish_indent
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

vim.cmd([[
  augroup fish_format
    autocmd!
    autocmd BufWritePre *.fish silent %!fish_indent
  augroup END
]])
