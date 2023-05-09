local ft_list = {
	"bash",
	"fish",
	"go",
	"hcl",
	"json",
	"lua",
	"make",
	"proto",
	"python",
	"rust",
	"toml",
	"vim",
	"yaml",
}
return {
	"gpanders/editorconfig.nvim",
	{
		"sheerun/vim-polyglot",
		init = function()
			vim.g.polyglot_disabled = vim.tbl_map(function(ft)
				return ft .. ".plugin"
			end, ft_list)
		end,
		priority = 950, -- without this, polyglot is effective only to the first buffer
	},
	{
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				ensure_installed = ft_list,
				highlight = {
					enable = true,
				},
			})
			-- require('nvim-treesitter.highlight').set_custom_captures({
			--   operator = "Special",
			--   namespace = "TSNone",
			--   ["function"] = "Include",
			--   ["function.call"] = "TSFunction",
			--   ["function.builtin"] = "TSFunction",
			--   ["method"] = "Include",
			--   ["method.call"] = "TSMethod",
			--   variable = "Normal",
			--   parameter = "Normal",
			--   field = "TSNone", -- field of struct initialisation
			--   property = "TSNone", -- field of struct definition, but this affects the property after `.` like time.Second
			-- })
			vim.wo.foldmethod = "expr"
			vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
			vim.wo.foldlevel = 99
		end,
		build = function()
			local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
			ts_update()
		end,
	},
}
