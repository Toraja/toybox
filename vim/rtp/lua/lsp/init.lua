local M = {}

function M.create_format_autocmd(opts)
  opts = opts or {}

  vim.b.auto_format_disabled = opts.disabled

  local auto_format_augroud_id = vim.api.nvim_create_augroup('lsp_auto_format', {})
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = auto_format_augroud_id,
    callback = function()
      if vim.b.auto_format_disabled then
        return
      end
      preserve_cursor(function()
        vim.lsp.buf.format({ async = false })
      end)
    end,
  })
end

function M.toggle_auto_format()
  vim.b.auto_format_disabled = not vim.b.auto_format_disabled
  if vim.b.auto_format_disabled then
    print('Auto format disabled')
  else
    print('Auto format enabled')
  end
end

return M
