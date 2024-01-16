return {
	{
		"kevinhwang91/nvim-bqf",
		config = function()
			local augroud_id = vim.api.nvim_create_augroup("nvim-bpf-custom", {})
			vim.api.nvim_create_autocmd("FileType", {
				group = augroud_id,
				desc = "Overwrite things set by nvim-bqf",
				pattern = "qf",
				callback = function()
					vim.opt_local.signcolumn = "yes"
				end,
			})
		end,
		event = "VeryLazy",
	},
	{
		"yorickpeterse/nvim-pqf",
		opts = {},
		event = "VeryLazy",
	},
}
