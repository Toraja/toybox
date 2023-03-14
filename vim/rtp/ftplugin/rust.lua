require('keymap.which-key-helper').register_for_ftplugin('Rust', {
  b = { 'Cbuild', { desc = '' } },
  B = { 'RustToggleBackTrace', { desc = '' } },
  g = { 'Cdebug', { desc = '' } },
  r = { 'CrunIns', { desc = '' } },
})

require("text.edit").map_toggle_trailing(';', ';', true)
