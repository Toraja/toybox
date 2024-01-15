return {
	{
		"ahmedkhalf/project.nvim",
		config = function()
			require("project_nvim").setup({
				-- Use `pattern` method over `lsp` becuase:
				-- If the filetype of the second buffer is same as the first, both are attached to the same LSP instance.
				-- Hence, even if they are in different project, LSP returns the root directory of the first buffer even on the second.
				detection_methods = { "pattern", "lsp" },
				-- Add some language specific files as project.nvim depends on lsp, it cd into different directory if the current buffer is not supported by lsp.
				patterns = vim.list_extend(
					require("project_nvim.config").defaults.patterns,
					{ "go.mod", "Cargo.toml", "justfile" }
				),
				scope_chdir = "win",
			})
		end,
	},
}
