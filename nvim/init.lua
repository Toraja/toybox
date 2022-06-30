function delete_hidden_buffers()
  local array = require('util.array')

  local visible_buffers = array.new()
  for i = 1, vim.fn.tabpagenr('$') do
    visible_buffers:append(vim.fn.tabpagebuflist(i))
  end

  local hidden_bufs = array.new()
  for i = 1, vim.fn.bufnr('$') do
    if vim.fn.bufexists(i) == 1 and not visible_buffers:contains(i) then
      hidden_bufs:insert(i)
    end
  end

  hidden_bufs:for_each(function(bufnr)
    vim.cmd(string.format('silent bwipeout %s', bufnr))
  end)
end

vim.api.nvim_create_user_command('DeleteHiddenBuffers', delete_hidden_buffers, {})
