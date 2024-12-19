return {
	{
		"folke/which-key.nvim",
		priority = 900,
		config = function()
			vim.api.nvim_set_hl(0, "FloatBorder", { link = "Normal" })
			vim.api.nvim_set_hl(0, "WhichKeyFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "WhichKey", { link = "Title" })
			vim.api.nvim_set_hl(0, "WhichKeyDesc", { link = "Type" })
			require("which-key").setup({
				keys = {
					scroll_down = "<PageDown>", -- binding to scroll down inside the popup
					scroll_up = "<PageUp>", -- binding to scroll up inside the popup
				},
				win = {
					-- don't allow the popup to overlap with the cursor
					no_overlap = false,
					border = "rounded", -- none, single, double, shadow
					padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
					wo = {
						winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
					},
				},
				layout = {
					height = { min = 4, max = 25 }, -- min and max height of the columns
					width = { min = 20, max = 50 }, -- min and max width of the columns
					spacing = 5, -- spacing between columns
					align = "left", -- align columns left, center or right
				},
				icons = {
					mappings = false,
				},
			})
		end,
	},
	{
		"anuvyklack/keymap-amend.nvim",
	},
}
