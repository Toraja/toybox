vim.b.yaml_auto_lint_disabled = false

function yaml_auto_lint_toggle()
  vim.b.yaml_auto_lint_disabled = not vim.b.yaml_auto_lint_disabled
end

function yaml_lint(opts)
  opts = opts or {}
  local file = assert(io.popen('yamllint --format parsable ' .. vim.fn.expand('%'), 'r'))
  local lint_result = vim.trim(assert(file:read('*a')))
  file:close()
  if lint_result == '' then
    vim.fn.setloclist(0, {})
    vim.cmd('lclose')
    if not opts.silent then
      print('yamllint done')
    end
    return
  end
  local lint_result_lines = vim.split(lint_result, '\n')
  vim.fn.setloclist(0, {}, ' ', { lines = lint_result_lines, title = 'yamllint' })
  vim.cmd('lwindow')
end

local yaml_lint_augroud_id = vim.api.nvim_create_augroup('yaml_lint', {})
vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
  group = yaml_lint_augroud_id,
  buffer = 0,
  callback = function()
    if vim.yaml_lint_auto_disabled then
      return
    end
    yaml_lint({ silent = true })
  end,
})

require('keymap.which-key-helper').register_for_ftplugin({
  l = { 'lua yaml_lint()', { desc = 'Lint', silent = true } },
  L = { 'lua yaml_auto_lint_toggle()', { desc = 'Toggle auto lint', silent = true } },
})
