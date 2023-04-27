local M = {}

function M.setup(opts)
	opts = opts or {}

	require("auto-format").setup({
		excluded_filetypes = { "go", "rust" },
	})

	require("keymap.which-key-helper").register_with_editable("ftplugin", "<LocalLeader>", "<LocalLeader>", {
		f = { "lua vim.lsp.buf.format()", { desc = "Format", silent = true } },
		F = { "lua require('auto-format').toggle()", { desc = "Toggle auto format", silent = true } },
	})
end

return M
