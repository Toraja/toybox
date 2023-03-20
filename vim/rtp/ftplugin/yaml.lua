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

require('keymap.which-key-helper').register_for_ftplugin({
  l = { 'lua yaml_lint()', { desc = 'Lint', silent = true } },
})

require('lsp').create_format_autocmd()
