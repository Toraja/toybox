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

function named_registers_clear()
  local ascii_code_a, ascii_code_z = string.byte('a'), string.byte('z')
  for i = ascii_code_a, ascii_code_z do
    vim.fn.setreg(string.char(i), {})
  end
  -- Make the changes to registers permanent by running the command below,
  -- or the registers will come back alive on the next launch of nvim
  vim.cmd('wshada!')
  print('All named registers have been cleared')
end

vim.api.nvim_create_user_command('NamedRegistersClear', named_registers_clear, {})
