return {
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			vim.opt.showmode = false

			local function mode_with_paste()
				local lualine_mode_map = require("lualine.utils.mode").map
				local mode = lualine_mode_map[vim.api.nvim_get_mode().mode]
				if vim.opt.paste:get() then
					mode = mode .. "(PASTE)"
				end
				return mode
			end

			local function get_current_win_cwd_with_tilda()
				return string.gsub(vim.fn.getcwd(0), "^" .. vim.loop.os_homedir(), "~", 1)
			end

			require("lualine").setup({
				options = {
					theme = "ayu_mirage",
					component_separators = "",
					disabled_filetypes = {
						-- statusline = {},
						winbar = {
							"dapui_scopes",
							"dapui_breakpoints",
							"dapui_stacks",
							"dapui_watches",
							"dap-repl",
							"dapui_console",
							-- "help",
							"qf",
							"gitcommit",
							"toggleterm",
						},
					},
				},
				sections = {
					lualine_a = { mode_with_paste },
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { get_current_win_cwd_with_tilda },
					lualine_x = { "searchcount", "encoding", "fileformat", "filetype" },
				},
				inactive_sections = {
					lualine_c = { get_current_win_cwd_with_tilda },
					lualine_x = { "location" },
				},
				winbar = {
					lualine_a = {
						{
							function()
								return vim.api.nvim_win_get_number(0)
							end,
						},
					},
					lualine_b = {
						{ "filetype", icon_only = true },
						-- shorting_target does not consider that window is vertically split
						{ "filename", newfile_status = true, path = 1 },
					},
				},
				inactive_winbar = {
					lualine_a = {
						{
							function()
								return vim.api.nvim_win_get_number(0)
							end,
						},
					},
					lualine_c = {
						{ "filetype", icon_only = true },
						{ "filename", newfile_status = true, path = 1 },
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
