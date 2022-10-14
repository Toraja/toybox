-- local todo_line_ptn = '^\([ \t]*- \[.\+\]\) \(.*\)'
local started_symbol = 'STARTED '
local blocked_symbol = 'BLOCKED '

local mkdnflow = require('mkdnflow')
vim.keymap.set('n', ']]', function() mkdnflow.cursor.toHeading(nil) end, { desc = 'Jump to next heading' })
vim.keymap.set('n', '[[', function() mkdnflow.cursor.toHeading(nil, {}) end, { desc = 'Jump to previous heading' })
vim.keymap.set('n', 'o', function() mkdnflow.lists.newListItem(false, false, true, 'i', 'o') end,
  { desc = 'Add list item below' })
vim.keymap.set('n', 'O', function() mkdnflow.lists.newListItem(false, true, true, 'i', 'O') end,
  { desc = 'Add list item above' })
vim.keymap.set('n', '<C-]>', function() mkdnflow.links.followLink() end, { desc = 'Follow link' })
vim.keymap.set('n', '<C-t><C-]>', function() vim.cmd('tab split'); mkdnflow.links.followLink() end,
  { desc = 'Follow link in tab' })
vim.keymap.set('n', '<C-w><C-]>', function() vim.cmd('split'); mkdnflow.links.followLink() end,
  { desc = 'Follow link in horizontal window' })

require('keymap.which-key-helper').register_with_editable('Markdown', '-', '-', {
  { 'b', 'ToDoToggleStatus ' .. blocked_symbol, { desc = 'Toggle BLOCKED' } },
  { 'c', 'ConcealToggle', { desc = 'Toggle conceallevel between 0 and 2' } },
  { 'd', 'MkdnToggleToDo', { desc = 'Toggle TODO status' } },
  -- { 'D', '', { desc = 'Remove TODO Checkbox' } },
  { 'f', 'MkdnFoldSection', { desc = 'Fold Section' } },
  { 'F', 'MkdnUnfoldSection', { desc = 'Unfold Section' } },
  -- { 'l', '', { desc = 'Toggle list' } },
  { 'p', 'ToDoAddPomodoro', { desc = 'Add pomodoro' } },
  { 's', 'ToDoToggleStatus ' .. started_symbol, { desc = 'Toggle STARTED' } },
})
