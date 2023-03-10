function yaml_lint()
  vim.cmd("lgetexpr system('yamllint --format parsable ' . expand('%'))")
  if #(vim.fn.getloclist(0)) ~= 0 then
    vim.cmd('Trouble loclist')
  else
    vim.cmd('TroubleClose')
  end
end

local yaml_lint_augroud_id = vim.api.nvim_create_augroup('yaml_lint', {})
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = yaml_lint_augroud_id,
  buffer = 0,
  callback = function()
    yaml_lint()
  end,
})

local function yaml_format()
  preserve_cursor(function()
    vim.cmd('silent %!yamlfmt -')
  end)
end

local yaml_format_augroud_id = vim.api.nvim_create_augroup('yaml_format', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  group = yaml_format_augroud_id,
  buffer = 0,
  callback = function()
    yaml_format()
  end,
})

require('keymap.which-key-helper').register_for_ftplugin('Yaml', {
  f = { 'lua yaml_format()', { desc = 'Format', silent = true, buffer = true } },
  l = { 'lua yaml_lint()', { desc = 'Lint', silent = true, buffer = true } },
})
