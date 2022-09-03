-- Setting enforced by fish_indent
vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.shiftwidth = 4

local function fish_format()
  preserve_cursor(function()
    vim.cmd('silent %!fish_indent')
  end)
end

local fish_format_augroud_id = vim.api.nvim_create_augroup('fish_format', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = fish_format_augroud_id,
  pattern = '*.fish',
  callback = function()
    fish_format()
  end,
})
