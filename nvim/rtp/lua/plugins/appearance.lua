return {
	{
		-- "cpea2506/one_monokai.nvim",
		"Toraja/one_monokai.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("one_monokai").setup({
				colors = {
					bg = "NONE",
					white = "#d7d7dd", -- original white is too blueish
					cyan = "#00d7ff",
					claret = "#7f1734",
					castleton_green = "#00563f",
					dark_powder_blue = "#003399",
					cursor_line_bg = "#141414",
					cursor_column_bg = "#242424",
					nvim_blue = "#1174b1",
					nvim_green = "#558f34",
					nvim_bg = "#081218",
				},
				themes = function(colors)
					return {
						-- builtin
						Comment = { fg = colors.gray },
						CursorLine = { bg = colors.cursor_line_bg },
						CursorLineNr = { fg = colors.fg, bg = colors.cursor_line_bg },
						CursorColumn = { bg = colors.cursor_column_bg },
						DiffAdd = { bg = colors.castleton_green },
						DiffDelete = { fg = colors.white, bg = colors.claret },
						DiffChange = { bg = colors.dark_gray },
						DiffText = { bg = colors.dark_powder_blue },
						Search = { fg = colors.yellow, bg = colors.bg, reverse = true },
						QuickFixLine = { underline = true },
						TabLineSel = { fg = colors.white, bg = colors.dark_blue, bold = true },
						TabLineSelSeparator = { fg = colors.dark_blue },
						TabLine = { fg = colors.gray, bg = colors.none },
						TabLineFill = { fg = colors.none, bg = colors.none },
						TabLineLogoLeft = { fg = "#000000", bg = colors.nvim_blue },
						TabLineLogoRight = { fg = "#000000", bg = colors.nvim_green },
						Todo = { fg = colors.pink, bold = true, reverse = false },
						-- custom
						AnnoyingSpaces = { bg = colors.dark_gray },
						Started = { fg = colors.pink, bold = true, reverse = true },
						Blocked = { fg = colors.aqua, bold = true, reverse = true },
						-- nvim-treesitter-context
						TreesitterContextSeparator = { link = "Comment" },
					}
				end,
			})
		end,
	},
	{
		"tanvirtin/monokai.nvim",
		enabled = false,
		lazy = false,
		priority = 1000,
		config = function()
			require("monokai").setup({
				palette = require("monokai").pro,
				-- palette = require('monokai').soda,
				-- palette = require('monokai').ristretto,
				custom_hlgroups = {
					Normal = { bg = "#000000" },
					CursorLine = { bg = "#151515" },
					TabLine = { reverse = true },
					AnnoyingSpaces = { bg = "#333842" },
				},
			})
		end,
	},
	{
		"nvim-tree/nvim-web-devicons",
		lazy = true,
		config = function()
			require("nvim-web-devicons").setup({})
		end,
	},
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
			local color_scheme = require("one_monokai.colors")
			local theme = require("lualine.themes.ayu_dark")
			theme.normal.a.bg = color_scheme.nvim_blue
			theme.insert.a.bg = color_scheme.nvim_green
			theme.visual.a.bg = "#bfa359"
			theme.replace.a.bg = "#c04148"
			theme.terminal = theme.insert

			local active_b_fg = color_scheme.white
			theme.normal.b.fg = active_b_fg
			theme.insert.b.fg = active_b_fg
			theme.visual.b.fg = active_b_fg
			theme.replace.b.fg = active_b_fg
			theme.inactive.b.fg = color_scheme.gray

			theme.normal.c.bg = "NONE"
			theme.inactive.c.bg = "NONE"

			local winbar_config = {
				-- lualine_a = {
				-- 	{
				-- 		function()
				-- 			return "[" .. vim.api.nvim_win_get_number(0) .. "]"
				-- 		end,
				-- 		-- separator = { left = "" },
				-- 		separator = { right = "" },
				-- 	},
				-- },
				lualine_b = {
					{
						function()
							return "[" .. vim.api.nvim_win_get_number(0) .. "]"
						end,
						padding = { left = 1, right = 0 },
					},
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
					theme = theme,
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
					-- "toggleterm",
				},
			})
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.api.nvim_set_hl(0, "IndentBlanklineChar", { ctermfg = 59 })
			vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", {}) -- this highlight overlaps cursorline. set None to prevent it.

			local hooks = require("ibl.hooks")
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_space_indent_level)
			hooks.register(hooks.type.WHITESPACE, hooks.builtin.hide_first_tab_indent_level)
			require("ibl").setup({
				indent = {
					char = "¦",
				},
				scope = {
					enabled = false,
				},
				exclude = {
					filetypes = { "help", "markdown", "json", "nerdtree", "NvimTree", "man" },
				},
			})
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("todo-comments").setup({
				highlight = {
					multiline = false,
					keyword = "bg", -- not inlclude space and colon
					after = "", -- highlight keyword only
				},
				colors = {
					info = { "Type" },
				},
			})
			vim.keymap.set("n", "<C-q><C-t>", "<Cmd>TodoQuickFix<CR>", { desc = "Todo in quickfix list" })
		end,
		event = "VeryLazy",
	},
}
