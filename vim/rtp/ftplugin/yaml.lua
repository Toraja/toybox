vim.b.yaml_auto_lint_disabled = false

function yaml_auto_lint_toggle()
  vim.b.yaml_auto_lint_disabled = not vim.b.yaml_auto_lint_disabled
end

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
    if vim.yaml_lint_auto_disabled then
      return
    end
    yaml_lint()
  end,
})

require('keymap.which-key-helper').register_for_ftplugin({
  l = { 'lua yaml_lint()', { desc = 'Lint', silent = true } },
  L = { 'lua yaml_auto_lint_toggle()', { desc = 'Toggle auto lint', silent = true } },
})

require('lsp').create_format_autocmd()
