local function clipboard_char()
  if vim.fn.has('xterm_clipboard') then
    return '+'
  end
  if vim.fn.has('clipboard') then
    return '*'
  end
  error('clipboard feature is not enabled.')
end

vim.keymap.set('n', '[Chief];', function()
  vim.fn.setreg(clipboard_char(), vim.fn.getreg('"'))
  print('Yanked text has been clipped')
end)

vim.keymap.set('n', 'yp', function()
  local current_file_path = vim.fn.expand('%:p:~')
  vim.fn.setreg('"', current_file_path)
  vim.fn.setreg(clipboard_char(), current_file_path)
  print('Clipped:', current_file_path)
end)
