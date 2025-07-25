vim.bo.expandtab = true
vim.bo.shiftwidth = 4

local my_php_augroud_id = vim.api.nvim_create_augroup("my_php", {})
vim.api.nvim_create_autocmd("BufWritePost", {
	group = my_php_augroud_id,
	pattern = "*.php",
	callback = function()
		vim.fn.PhpCsFixerFixFile()
	end,
})

require("text.edit").map_toggle_trailing(";", ";", true)

require("keymap.which-key-helper").register_for_ftplugin({
	c = { rhs = "PhpactorClassNew", opts = { desc = "PhpactorClassNew" } },
	C = { rhs = "PhpactorCopyFile", opts = { desc = "PhpactorCopyFile" } },
	d = { rhs = "!php artisan l5:generate", opts = { desc = "L5:generate" } },
	f = { rhs = "call PhpCsFixerFixFile()", opts = { desc = "PhpCsFixerFixFile()" } },
	F = { rhs = "PhpactorTransform", opts = { desc = "PhpactorTransform" } },
	i = { rhs = "PhpactorImportMissingClasses", opts = { desc = "PhpactorImportMissingClasses" } },
	m = { rhs = "PhpactorMoveFile", opts = { desc = "PhpactorMoveFile" } },
	M = { rhs = "PhpactorContextMenu", opts = { desc = "PhpactorContextMenu" } },
	r = { rhs = "vsplit | terminal php %", opts = { desc = "Run" } },
})
