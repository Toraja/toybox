-- Setting enforced by fish_indent
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

vim.cmd([[
  function s:FishFormat()
    let [_, l:currentline, l:currentcol, _] = getpos('.')
    silent %!fish_indent
    call cursor(l:currentline, l:currentcol)
  endfunction
  augroup fish_format
    autocmd!
    autocmd BufWritePre *.fish call s:FishFormat()
  augroup END
]])
