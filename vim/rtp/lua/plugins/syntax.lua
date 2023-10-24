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
		"mhartington/formatter.nvim",
		config = function()
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					fish = {
						require("formatter.filetypes.fish").fishindent,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					yaml = {
						require("formatter.filetypes.yaml").yamlfmt,
					},
				},
			})

			local ft_common = require("ft-common")
			ft_common.set_ft_keymap({
				f = { "Format", { desc = "Format", silent = true } },
			})

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("AutoFormat", {}),
				pattern = "*",
				callback = function()
					if ft_common.is_auto_format_disabled() then
						return
					end

					vim.cmd("FormatWrite")
				end,
			})
		end,
	},
}
