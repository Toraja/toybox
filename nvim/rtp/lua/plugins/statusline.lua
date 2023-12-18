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

			local function get_file_name()
				local filepath = vim.api.nvim_buf_get_name(0)

				if filepath == "" then
					local noname_filetype = vim.api.nvim_buf_get_option(0, "filetype")
					if noname_filetype == "qf" then
						local win_id = vim.api.nvim_get_current_win()
						local win_info_dict = vim.fn.getwininfo(win_id)[1]
						if win_info_dict.loclist == 1 then
							return "[Location]"
						end
						return "[Quickfix]"
					end
					return "[No Name]"
				end

				return vim.fn.fnamemodify(filepath, ":~:.")
			end

			require("lualine").setup({
				options = {
					-- theme = "ayu_mirage",
					theme = "ayu_dark",
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
							-- "qf",
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
						-- { "filename", newfile_status = true, path = 1 },
						{ get_file_name },
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
						-- { "filename", newfile_status = true, path = 1 },
						{ get_file_name },
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
