return {
	{
		"rcarriga/nvim-notify",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
			{ "anuvyklack/keymap-amend.nvim" },
		},
		config = function()
			vim.notify = require("notify")
			require("notify").setup({
				background_colour = "#000000",
				stages = "fade",
			})
			local keymap_amend = require("keymap-amend")
			keymap_amend("n", "<M-c>", function(original)
				original()
				vim.notify.dismiss()
			end, { desc = "Close notifications" })
		end,
	},
}
