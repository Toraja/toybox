vim.bo.smartindent = false
vim.bo.fixendofline = true -- python formatter requires EOL

require("keymap.which-key-helper").register_for_ftplugin({
	r = { rhs = "vsplit | terminal python %", opts = { desc = "Run" } },
})
