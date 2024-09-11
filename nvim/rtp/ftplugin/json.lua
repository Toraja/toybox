vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.tabstop = 2

if vim.fn.executable("vscode-json-language-server") == 1 then
	require("lspconfig")["jsonls"].setup({
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})
end
