if vim.fn.executable("taplo") == 1 then
	require("lspconfig")["taplo"].setup({
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})
end
