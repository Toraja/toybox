vim.bo.expandtab = true
vim.bo.shiftwidth = 4

if vim.fn.executable("phpactor") == 1 then
	require("lspconfig")["phpactor"].setup({
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
		-- taken from https://phpactor.readthedocs.io/en/master/lsp/vim.html
		init_options = {
			["language_server_phpstan.enabled"] = false,
			["language_server_psalm.enabled"] = false,
		},
	})
end

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
	c = { "PhpactorClassNew", { desc = "PhpactorClassNew" } },
	C = { "PhpactorCopyFile", { desc = "PhpactorCopyFile" } },
	d = { "!php artisan l5:generate", { desc = "L5:generate" } },
	f = { "call PhpCsFixerFixFile()", { desc = "PhpCsFixerFixFile()" } },
	F = { "PhpactorTransform", { desc = "PhpactorTransform" } },
	i = { "PhpactorImportMissingClasses", { desc = "PhpactorImportMissingClasses" } },
	m = { "PhpactorMoveFile", { desc = "PhpactorMoveFile" } },
	M = { "PhpactorContextMenu", { desc = "PhpactorContextMenu" } },
	r = { "vsplit | terminal php %", { desc = "Run" } },
})
