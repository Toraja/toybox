return {
	{
		"cpea2506/one_monokai.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("one_monokai").setup({
				colors = {
					bg = "NONE",
					cyan = "#00d7ff",
					claret = "#7f1734",
					castleton_green = "#00563f",
					dark_powder_blue = "#003399",
					cursor_line_bg = "#141414",
				},
				themes = function(colors)
					return {
						CursorLine = { bg = colors.cursor_line_bg },
						CursorLineNr = { fg = colors.fg, bg = colors.cursor_line_bg },
						DiffAdd = { bg = colors.castleton_green },
						DiffDelete = { fg = colors.white, bg = colors.claret },
						DiffChange = { bg = colors.dark_gray },
						DiffText = { bg = colors.dark_powder_blue },
						Search = { fg = colors.yellow, bg = colors.bg, reverse = true },
						QuickFixLine = { underline = true },
						TabLine = { fg = colors.dark_gray, bg = colors.none },
						TabLineFill = { fg = colors.none, bg = colors.none },
						Todo = { fg = colors.pink, bold = true, reverse = false },
						Started = { fg = colors.pink, bold = true, reverse = true },
						Blocked = { fg = colors.aqua, bold = true, reverse = true },
						AnnoyingSpaces = { bg = colors.dark_gray },
						TreesitterContextBottom = { underline = true },
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
		"IndianBoy42/tree-sitter-just",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
	},
}
