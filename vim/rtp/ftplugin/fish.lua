-- Setting enforced by fish_indent
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.cmd([[
  augroup fish_format
    autocmd!
    autocmd BufWritePre *.fish silent %!fish_indent
  augroup END
]])
