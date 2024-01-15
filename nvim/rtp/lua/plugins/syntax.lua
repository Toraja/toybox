return {
	{
		"nvim-treesitter/nvim-treesitter",
		dependencies = { "IndianBoy42/tree-sitter-just" },
		config = function()
			-- setup justfile parser
			---@diagnostic disable-next-line: inject-field
			require("nvim-treesitter.parsers").get_parser_configs().just = {
				install_info = {
					url = "https://github.com/IndianBoy42/tree-sitter-just", -- local path or git repo
					files = { "src/parser.c", "src/scanner.c" },
					branch = "main",
				},
				maintainers = { "@IndianBoy42" },
			}

			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"fish",
					"go",
					"gomod",
					"gosum",
					"hcl",
					"json",
					-- "just", -- disabling as it crushes
					"lua",
					"make",
					"markdown",
					"markdown_inline",
					"proto",
					"python",
					"rust",
					"toml",
					"vim",
					"vimdoc",
					"yaml",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "markdown" },
				},
				indent = {
					enable = true,
				},
			})
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
		"mhartington/formatter.nvim",
		config = function()
			require("formatter").setup({
				logging = true,
				log_level = vim.log.levels.WARN,
				filetype = {
					fish = {
						require("formatter.filetypes.fish").fishindent,
					},
					go = {
						function()
							local fmt = require("formatter.filetypes.go").golines()
							fmt.args = {
								"--max-len",
								"120",
								"--tab-len",
								"1", -- align with golangci-lint (lll)
								"--base-formatter",
								"gofumpt", -- goimports is super slow
							}
							return fmt
						end,
					},
					lua = {
						require("formatter.filetypes.lua").stylua,
					},
					toml = {
						require("formatter.filetypes.toml").taplo,
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
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				go = { "golangcilint" },
				yaml = { "yamllint" },
			}

			local ft_common = require("ft-common")
			ft_common.set_ft_keymap({
				l = { "lua require('lint').try_lint()", { desc = "Lint", silent = true } },
			})

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("AutoLint", {}),
				pattern = "*",
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
}
