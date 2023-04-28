local M = {}

function M.setup(opts)
	opts = opts or {}

	require("format").setup({
		excluded_filetypes = { "go", "rust" },
	})

	require("keymap.which-key-helper").register_with_editable("ftplugin", "<LocalLeader>", "<LocalLeader>", {
		f = { "lua require('format').run()", { desc = "Format", silent = true } },
		F = { "lua require('format').toggle_auto()", { desc = "Toggle auto format", silent = true } },
	})
end

return M
