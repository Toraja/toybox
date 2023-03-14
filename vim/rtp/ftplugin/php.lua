require('keymap.which-key-helper').register_for_ftplugin('PHP', {
  c = { 'PhpactorClassNew', { desc = 'PhpactorClassNew' } },
  C = { 'PhpactorCopyFile', { desc = 'PhpactorCopyFile' } },
  d = { '!php artisan l5:generate', { desc = 'L5:generate' } },
  f = { 'call PhpCsFixerFixFile()', { desc = 'PhpCsFixerFixFile()' } },
  F = { 'PhpactorTransform', { desc = 'PhpactorTransform' } },
  i = { 'PhpactorImportMissingClasses', { desc = 'PhpactorImportMissingClasses' } },
  m = { 'PhpactorMoveFile', { desc = 'PhpactorMoveFile' } },
  M = { 'PhpactorContextMenu', { desc = 'PhpactorContextMenu' } },
  r = { 'vsplit | terminal php %', { desc = 'Run' } },
})

require("text.edit").map_toggle_trailing(';', ';', true)
