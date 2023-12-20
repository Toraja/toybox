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

			local function get_quickfix_annotation()
				if vim.api.nvim_buf_get_option(0, "filetype") ~= "qf" then
					return ""
				end
				local win_id = vim.api.nvim_get_current_win()
				if require("qf").is_loclist_win(win_id) then
					return "[LOC]"
				end
				return "[QF]"
			end
			local ayu_mirage = require("lualine.themes.ayu_mirage")
			ayu_mirage.normal.c.bg = "NONE"
			ayu_mirage.inactive.c.bg = "NONE"

			local winbar_config = {
				lualine_a = {
					{
						function()
							return "[" .. vim.api.nvim_win_get_number(0) .. "]"
						end,
						-- separator = { left = "" },
						separator = { right = "" },
					},
				},
				lualine_b = {
					{ "filetype", icon_only = true, padding = { left = 2, right = 1 } },
					{ get_quickfix_annotation, padding = { left = 1, right = 0 } },
					-- shorting_target does not consider that window is vertically split
					{ "filename", newfile_status = true, path = 1 },
				},
				lualine_c = {
					-- without below, section C normal highlight configured above is not used and default color is used
					{ " ", draw_empty = true },
				},
			}

			require("lualine").setup({
				options = {
					theme = ayu_mirage,
					-- theme = "ayu_mirage",
					-- theme = "ayu_dark",
					-- component_separators = "",
					component_separators = "",
					section_separators = { left = "", right = "" },
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
					lualine_a = {
						{ mode_with_paste, separator = { right = "" }, padding = 2 },
						-- { mode_with_paste, separator = { left = "" }, padding = 2 },
					},
					lualine_b = { "branch", "diff", "diagnostics" },
					lualine_c = { get_current_win_cwd_with_tilda },
					lualine_x = { "searchcount", "encoding", "fileformat", "filetype" },
					lualine_z = {
						{ "location", separator = { left = "" }, padding = 2 },
						-- { "location", separator = { right = "" }, padding = 2 },
					},
				},
				inactive_sections = {
					lualine_c = { get_current_win_cwd_with_tilda },
					lualine_x = { "location" },
				},
				winbar = winbar_config,
				inactive_winbar = winbar_config,
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
