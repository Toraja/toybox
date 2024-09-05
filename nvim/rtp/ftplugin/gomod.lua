if vim.fn.executable("gopls") == 1 then
	require("lspconfig")["gopls"].setup({
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
	})
end
