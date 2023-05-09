return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.o.showmode = false

			local function mode_with_paste()
				local lualine_mode_map = require("lualine.utils.mode").map
				local mode = lualine_mode_map[vim.fn.mode()]
				if vim.o.paste then
					mode = mode .. " (PASTE)"
				end
				return mode
			end

			require("lualine").setup({
				options = {
					theme = "ayu_mirage",
					disabled_filetypes = {
						-- statusline = {},
						winbar = { "help", "qf", "gitcommit", "fugitive" },
					},
				},
				sections = {
					lualine_a = { mode_with_paste },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { "vim.fn.fnamemodify(vim.fn.getcwd(0), ':~')" },
				},
				inactive_sections = {
					lualine_c = { "vim.fn.fnamemodify(vim.fn.getcwd(0), ':~')" },
					lualine_x = { "location" },
				},
				winbar = {
					lualine_c = { { "filename", path = 1, newfile_status = true } },
				},
				inactive_winbar = {
					lualine_c = { { "filename", path = 1, newfile_status = true } },
				},
				extensions = { "aerial", "man", "nvim-tree", "quickfix", "symbols-outline", "toggleterm" },
			})
		end,
	},
}
