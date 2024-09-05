vim.bo.smartindent = false
vim.bo.fixendofline = true -- python formatter requires EOL

if vim.fn.executable("pyright") == 1 then
	require("lspconfig")["pyright"].setup({
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})
end

require("keymap.which-key-helper").register_for_ftplugin({
	r = { "vsplit | terminal python %", { desc = "Run" } },
})
