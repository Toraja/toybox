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
				plugins = {
					presets = {
						operators = false, -- adds help for operators like d, y, ...
					},
				},
				operators = {
					d = "Delete",
					c = "Change",
					y = "Yank (copy)",
					["g~"] = "Toggle case",
					["gu"] = "Lowercase",
					["gU"] = "Uppercase",
					[">"] = "Indent right",
					["<lt>"] = "Indent left",
					["zf"] = "Create fold",
					["!"] = "Filter though external program",
					-- ["v"] = "Visual Character Mode",
					gc = "Comments",
				},
				popup_mappings = {
					scroll_down = "<PageDown>", -- binding to scroll down inside the popup
					scroll_up = "<PageUp>", -- binding to scroll up inside the popup
				},
				window = {
					border = "rounded", -- none, single, double, shadow
					position = "bottom", -- bottom, top
					margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
					padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
					winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
				},
				layout = {
					height = { min = 4, max = 25 }, -- min and max height of the columns
					width = { min = 20, max = 50 }, -- min and max width of the columns
					spacing = 5, -- spacing between columns
					align = "left", -- align columns left, center or right
				},
			})
		end,
	},
	{
		"anuvyklack/keymap-amend.nvim",
	},
}
