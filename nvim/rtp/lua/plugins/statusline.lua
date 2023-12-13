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

			local function get_current_win_cwd_with_tilda()
				return string.gsub(vim.fn.getcwd(0), "^" .. vim.loop.os_homedir(), "~", 1)
			end

			require("lualine").setup({
				options = {
					theme = "ayu_mirage",
					disabled_filetypes = {
						-- statusline = {},
						winbar = {
							"dapui_scopes",
							"dapui_breakpoints",
							"dapui_stacks",
							"dapui_watches",
							"dap-repl",
							"dapui_console",
							"help",
							"qf",
							"gitcommit",
						},
					},
				},
				sections = {
					lualine_a = { mode_with_paste },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { get_current_win_cwd_with_tilda },
				},
				inactive_sections = {
					lualine_c = { get_current_win_cwd_with_tilda },
					lualine_x = { "location" },
				},
				winbar = {
					lualine_c = { { "filename", path = 1, newfile_status = true } },
				},
				inactive_winbar = {
					lualine_c = {
						{
							-- `filename` attribute only displays basename in inactive_winbar, so use DIY function.
							function()
								return string.gsub(vim.api.nvim_buf_get_name(0), "^" .. vim.fn.getcwd(0) .. "/", "", 1)
							end,
							newfile_status = true,
						},
					},
				},
				extensions = {
					"aerial",
					"man",
					"neo-tree",
					"nvim-dap-ui",
					"quickfix",
					"symbols-outline",
					"toggleterm",
				},
			})
		end,
	},
}
