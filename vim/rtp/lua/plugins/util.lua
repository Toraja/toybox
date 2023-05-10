return {
	{
		"rcarriga/nvim-notify",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				background_colour = "#000000",
				stages = "fade",
			})
		end,
	},
}
