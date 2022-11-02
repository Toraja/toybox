-- local todo_line_ptn = '^\([ \t]*- \[.\+\]\) \(.*\)'
local started_symbol = 'STARTED '
local blocked_symbol = 'BLOCKED '

local mkdnflow = require('mkdnflow')
vim.keymap.set('n', ']]', function() mkdnflow.cursor.toHeading(nil) end, { desc = 'Jump to next heading', buffer = true })
vim.keymap.set('n', '[[', function() mkdnflow.cursor.toHeading(nil, {}) end,
  { desc = 'Jump to previous heading', buffer = true })
vim.keymap.set('n', 'o', function() mkdnflow.lists.newListItem(false, false, true, 'i', 'o') end,
  { desc = 'Add list item below', buffer = true })
vim.keymap.set('n', 'O', function() mkdnflow.lists.newListItem(false, true, true, 'i', 'O') end,
  { desc = 'Add list item above', buffer = true })
vim.keymap.set('n', '<C-]>', function() mkdnflow.links.followLink() end, { desc = 'Follow link', buffer = true })
vim.keymap.set('n', '<C-t><C-]>', function() vim.cmd('tab split'); mkdnflow.links.followLink() end,
  { desc = 'Follow link in tab', buffer = true })
vim.keymap.set('n', '<C-w><C-]>', function() vim.cmd('split'); mkdnflow.links.followLink() end,
  { desc = 'Follow link in horizontal window', buffer = true })

require('keymap.which-key-helper').register_with_editable('Markdown', '-', '-', {
  { 'b', 'ToDoToggleStatus ' .. blocked_symbol, { desc = 'Toggle BLOCKED', buffer = true } },
  { 'c', 'ConcealToggle', { desc = 'Toggle conceallevel between 0 and 2', buffer = true } },
  { 'd', 'MkdnToggleToDo', { desc = 'Toggle TODO status', buffer = true } },
  -- { 'D', '', { desc = 'Remove TODO Checkbox', buffer = true } },
  { 'f', 'MkdnFoldSection', { desc = 'Fold Section', buffer = true } },
  { 'F', 'MkdnUnfoldSection', { desc = 'Unfold Section', buffer = true } },
  -- { 'l', '', { desc = 'Toggle list', buffer = true } },
  { 'p', 'ToDoAddPomodoro', { desc = 'Add pomodoro', buffer = true } },
  { 's', 'ToDoToggleStatus ' .. started_symbol, { desc = 'Toggle STARTED', buffer = true } },
}, { buffer = 0 })
