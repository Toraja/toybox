vim.bo.smartindent = false
vim.bo.fixendofline = true -- python formatter requires EOL

require('keymap.which-key-helper').register_for_ftplugin('Python', {
	r = { 'vsplit | terminal python %', { desc = 'Run' } },
})

require('lsp').create_format_autocmd()
