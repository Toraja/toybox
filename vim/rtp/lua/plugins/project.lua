return {
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				-- Add some language specific files as project.nvim depends on lsp, it cd into different directory if the current buffer is not supported by lsp.
				patterns = vim.list_extend(
					require("project_nvim.config").defaults.patterns,
					{ "go.mod", "Cargo.toml" }
				),
				scope_chdir = "win",
			})
		end,
	},
}
