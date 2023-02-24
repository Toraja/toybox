require('nvim-surround').buffer_setup({
  surrounds = {
    v = {
      ---@diagnostic disable-next-line: assign-type-mismatch
      add = { "{{ ", " }}" },
      find = function()
        return require('nvim-surround.config').get_selection({ pattern = '{{ [^}]* }}' })
      end,
      ---@diagnostic disable-next-line: assign-type-mismatch
      delete = '^(.. ?)().-( ?..)()$',
      change = {
        ---@diagnostic disable-next-line: assign-type-mismatch
        target = '({{ ?)()[^}]*( }})()',
      },
    },
  }
})

function yaml_lint()
  vim.cmd("lgetexpr system('yamllint --format parsable ' . expand('%'))")
  if #(vim.fn.getloclist(0)) ~= 0 then
    vim.cmd('Trouble loclist')
  else
    vim.cmd('TroubleClose')
  end
end

require('keymap.which-key-helper').register_for_ftplugin('Yaml', {
  l = { 'lua yaml_lint()', { desc = 'Lint', silent = true, buffer = true } },
})

-- Disable autocmd as some yaml files are not genuine yaml file (such as helm chart).
-- local yaml_lint_augroud_id = vim.api.nvim_create_augroup('yaml_lint', {})
-- vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
--   group = yaml_lint_augroud_id,
--   pattern = '*.yaml',
--   callback = yaml_lint,
-- })
