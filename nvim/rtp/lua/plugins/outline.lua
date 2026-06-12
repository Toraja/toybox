return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				max_lines = 12,
				multiline_threshold = 6,
				separator = "⁃", -- U+2043 : HYPHEN BULLET
			})
		end,
	},
	{
		"hedyhli/outline.nvim",
		config = function()
			require("outline").setup({
				focus_on_open = false, -- Seems not working. :OutLine (no bang) still forcuses on outline buffer
			})
		end,
		keys = {
			{ "<Leader>o", "<Cmd>Outline!<CR>", mode = { "n" }, desc = "Toggle Outline" },
			{
				"<Leader>O",
				function()
					local focused = require("outline")._sidebar_do("focus_toggle")
					if not focused then
						require("outline").open_outline()
					end
				end,
				mode = { "n" },
				desc = "Toggle focus between Outline and source window. Open Outline if it's not open",
			},
		},
	},
}
