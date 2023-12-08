vim.opt_local.conceallevel = 0
vim.opt_local.foldmethod = 'marker'

local started_symbol = 'STARTED '
local blocked_symbol = 'BLOCKED '
local todo_line_ptn = '^([ \t]*)(- %[(.)%])( .*)'

local function is_todo_line(line)
  return string.match(line, todo_line_ptn) ~= nil
end

local function get_todo_checkbox_state(line)
  if not is_todo_line(line) then
    return
  end

  return string.gsub(line, todo_line_ptn, '%3')
end

local function todo_toggle_cancelled(line)
  if not is_todo_line(line) then
    return
  end

  local new_checkbox_state = get_todo_checkbox_state(line) == '~' and ' ' or '~'
  local cancelled_todo = string.gsub(line, todo_line_ptn, '%1- [' .. new_checkbox_state .. ']%4')
  vim.fn.setline('.', cancelled_todo)
end

vim.api.nvim_create_user_command('ToggleToDoCancelled', function() todo_toggle_cancelled(vim.fn.getline('.')) end, {})


require('keymap.which-key-helper').register_for_ftplugin({
  b = { 'ToDoToggleStatus ' .. blocked_symbol, { desc = 'Toggle BLOCKED' } },
  c = { 'ConcealToggle', { desc = 'Toggle conceallevel between 0 and 2' } },
  d = { 'MkdnToggleToDo', { desc = 'Toggle TODO status' } },
  -- D = { '', { desc = 'Remove TODO Checkbox' } },
  f = { 'MkdnFoldSection', { desc = 'Fold Section', } },
  F = { 'MkdnUnfoldSection', { desc = 'Unfold Section' } },
  -- l = { '', { desc = 'Toggle list' } },
  p = { 'ToDoAddPomodoro', { desc = 'Add pomodoro' } },
  s = { 'ToDoToggleStatus ' .. started_symbol, { desc = 'Toggle STARTED' } },
  v = { 'Glow', { desc = 'Glow' } },
  x = { 'ToggleToDoCancelled', { desc = 'Cancel TODO' } },
})
