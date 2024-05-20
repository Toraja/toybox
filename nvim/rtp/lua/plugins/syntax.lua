return {
	{
		"nvim-treesitter/nvim-treesitter",
		-- version = "*", -- current latest version (0.9.2) does not include some parsers like just and helm
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				ensure_installed = {
					"bash",
					"css",
					"csv",
					"diff",
					"fish",
					"go",
					"gomod",
					"gosum",
					"hcl",
					"helm",
					"html",
					"ini",
					"json",
					"just",
					"lua",
					"luadoc",
					"luap", -- lua patterns
					"make",
					"markdown",
					"markdown_inline",
					"proto",
					"python",
					"query", -- treesitter query
					-- "regex", -- not sure how/when this works
					"rust",
					"sql",
					"ssh_config",
					"terraform", -- this is alias to hcl but this is needed for tf files
					"toml",
					"vim",
					"vimdoc",
					"xml",
					"yaml",
				},
				highlight = {
					enable = true,
					-- additional_vim_regex_highlighting = { "markdown" },
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
					-- golines does not recognise `nolint:lll` comment and that is troubling
					-- go = {
					-- 	function()
					-- 		local fmt = require("formatter.filetypes.go").golines()
					-- 		fmt.args = {
					-- 			"--max-len",
					-- 			"120",
					-- 			"--tab-len",
					-- 			"1", -- align with golangci-lint (lll)
					-- 			"--base-formatter",
					-- 			"gofumpt", -- goimports is super slow
					-- 		}
					-- 		return fmt
					-- 	end,
					-- },
					json = {
						require("formatter.filetypes.json").jq,
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
		event = "VeryLazy",
	},
	{
		"mfussenegger/nvim-lint",
		config = function()
			local lint = require("lint")
			lint.linters_by_ft = {
				go = { "golangcilint" },
				yaml = { "yamllint" },
			}

			local severities = {
				error = "E",
				warning = "W",
				refactor = "I",
				convention = "H",
			}

			local custom_linters = { go = { "golangcilint_ws" } }
			local golangcilint_ws = vim.deepcopy(require("lint.linters.golangcilint"))
			golangcilint_ws.args = {
				"run",
				"--out-format",
				"json",
				"--max-issues-per-linter",
				"100",
				"--max-same-issues",
				"100",
			}
			golangcilint_ws.parser = function(output, _, cwd)
				if output == "" then
					return {}
				end
				local decoded = vim.json.decode(output)
				if decoded["Issues"] == nil or type(decoded["Issues"]) == "userdata" then
					return {}
				end

				local qfs = {}
				for _, item in ipairs(decoded["Issues"]) do
					local linted_file = cwd .. "/" .. item.Pos.Filename
					table.insert(qfs, {
						filename = linted_file,
						lnum = item.Pos.Line > 0 and item.Pos.Line or 0,
						col = item.Pos.Column > 0 and item.Pos.Column or 0,
						end_lnum = item.Pos.Line > 0 and item.Pos.Line or 0,
						end_col = item.Pos.Column > 0 and item.Pos.Column or 0,
						type = severities[item.Severity] or severities.warning,
						text = item.Text,
					})
				end
				vim.fn.setqflist(qfs)
				if vim.tbl_count(qfs) ~= 0 then
					vim.cmd("copen")
				end
				return {}
			end
			lint.linters.golangcilint_ws = golangcilint_ws

			local ft_common = require("ft-common")
			ft_common.set_ft_keymap({
				l = { "lua require('lint').try_lint()", { desc = "Lint", silent = true } },
			})

			vim.api.nvim_create_user_command("LintCustom", function(cmds)
				lint.try_lint({ cmds.fargs[1] })
			end, {
				nargs = 1,
				complete = function(_, _, _)
					return custom_linters[vim.api.nvim_buf_get_option(0, "filetype")]
				end,
			})

			vim.api.nvim_create_autocmd("BufWritePost", {
				group = vim.api.nvim_create_augroup("AutoLint", {}),
				pattern = "*",
				callback = function()
					lint.try_lint()
				end,
			})
		end,
		event = "VeryLazy",
		cmd = { "LintCustom" },
	},
}
