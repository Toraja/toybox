return {
	"tpope/vim-repeat",
	{
		"tpope/vim-abolish",
		init = function()
			vim.g.abolish_no_mappings = 1
		end,
	},
	{
		"gbprod/yanky.nvim",
		dependencies = {
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			local utils = require("yanky.utils")
			local mapping = require("yanky.telescope.mapping")
			require("yanky").setup({
				highlight = {
					on_put = false,
					on_yank = false,
				},
				picker = {
					telescope = {
						mappings = {
							default = mapping.put("p"),
							i = {
								["<M-CR>"] = mapping.put("P"),
								["<c-k>"] = mapping.delete(),
								["<c-r>"] = mapping.set_register(utils.get_default_register()),
							},
							n = {
								p = mapping.put("p"),
								P = mapping.put("P"),
								d = mapping.delete(),
								r = mapping.set_register(utils.get_default_register()),
							},
						},
					},
				},
			})
			vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
			vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
			vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
			vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
			vim.keymap.set("n", "<M-p>", "<Plug>(YankyCycleForward)")
			vim.keymap.set("n", "<M-P>", "<Plug>(YankyCycleBackward)")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			vim.api.nvim_set_hl(0, "IndentBlanklineChar", { ctermfg = 59 })
			vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", {}) -- this highlight overlaps cursorline. set None to prevent it.

			require("indent_blankline").setup({
				char = "¦",
				show_first_indent_level = false,
				filetype_exclude = { "help", "markdown", "json", "nerdtree", "NvimTree", "man" },
			})
		end,
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			local ft = require("Comment.ft")
			require("Comment").setup({
				ignore = "^$",
				ft.set("asciidoc", { "//%s", "////%s////" }),
			})
			-- XXX not working
			-- vim.keymap.set('i', '<C-\\>', '<C-o>gcc', { remap = true, silent = true } )
			vim.keymap.set("n", "gcy", "yy<Plug>(comment_toggle_linewise_current)", { silent = true })
			vim.keymap.set("x", "gCy", "ygv<Plug>(comment_toggle_linewise_visual)", { silent = true })
		end,
	},
	{
		"gbprod/substitute.nvim",
		dependencies = {
			{ "gbprod/yanky.nvim" },
		},
		config = function()
			require("substitute").setup({
				highlight_substituted_text = {
					enabled = false,
				},
				range = {
					prefix = "substitute",
					prompt_current_text = true,
					confirm = true,
				},
			})
			vim.keymap.set(
				"n",
				"cp",
				require("substitute").operator,
				{ desc = "Replace operator text with yanked text" }
			)
			vim.keymap.set("n", "cpp", function()
				require("substitute").operator({ motion = "iw" })
			end, { desc = "Replace operator text with yanked text" })
			-- vim.keymap.set('n', 'cpp', require('substitute').line, { desc = 'Replace whole line with yanked text' })
			-- vim.keymap.set('n', 'cP', require('substitute').eol, { desc = 'Replace text to EOL with yanked text' })
			vim.keymap.set("x", "cp", require("substitute").visual, { desc = "Replace visual text with yanked text" })

			vim.keymap.set(
				"n",
				"<Leader>c",
				require("substitute.range").operator,
				{ desc = "Substitute operator text within the range" }
			)
			vim.keymap.set(
				"x",
				"<Leader>c",
				require("substitute.range").visual,
				{ desc = "Substitute visual text within the range" }
			)
			-- vim.keymap.set('n', '<Leader>cc', require('substitute.range').word,
			--   { desc = 'Substitute cursor word within the range' })
			vim.keymap.set("n", "<Leader>cc", function()
				require("substitute.range").operator({ motion1 = "iw" })
			end, { desc = "Substitute cursor word within the range" })

			vim.keymap.set("n", "cx", require("substitute.exchange").operator, { desc = "Swap operator text" })
			vim.keymap.set("n", "cxx", function()
				require("substitute.exchange").operator({ motion = "iw" })
			end, { desc = "Swap cursor word" })
			-- vim.keymap.set('n', 'cxx', require('substitute.exchange').line), { desc = 'Swap whole line'}
			vim.keymap.set("x", "X", require("substitute.exchange").visual, { desc = "Swap visual text" })
			vim.keymap.set("n", "cxc", require("substitute.exchange").cancel, { desc = "Cancel swapping text" })
		end,
	},
	{
		"johmsalas/text-case.nvim",
		dependencies = {
			{ "folke/which-key.nvim" },
		},
		config = function()
			local textcase = require("textcase")
			local prefix = "ga"
			local key_api_table = {
				u = textcase.api.to_upper_case,
				l = textcase.api.to_lower_case,
				s = textcase.api.to_snake_case,
				h = textcase.api.to_dash_case,
				n = textcase.api.to_constant_case,
				d = textcase.api.to_dot_case,
				a = textcase.api.to_phrase_case,
				c = textcase.api.to_camel_case,
				p = textcase.api.to_pascal_case,
				t = textcase.api.to_title_case,
				f = textcase.api.to_path_case,
			}
			for key, api in pairs(key_api_table) do
				textcase.register_keybindings(prefix, api, {
					quick_replace = key,
					operator = "o" .. key,
					visual = key,
				})
			end

			local wk = require("which-key")
			wk.register({
				[prefix] = {
					name = "text-case",
				},
			}, { mode = "v" })

			wk.register({
				[prefix] = {
					name = "text-case",
					o = {
						name = "Pending mode operator",
					},
				},
			}, { mode = "n" })
		end,
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			require("nvim-surround").setup({
				keymaps = {
					insert = false,
					insert_line = false,
					normal = "yr",
					normal_cur = "yrr",
					normal_line = "yR",
					normal_cur_line = "yRR",
					visual = "R",
					visual_line = "gR",
					delete = "dr",
					change = "cr",
				},
				surrounds = {
					["d"] = {
						---@diagnostic disable-next-line: assign-type-mismatch
						add = { "${", "}" },
						find = function()
							return require("nvim-surround.config").get_selection({ pattern = "%${[^}]*}" })
						end,
						---@diagnostic disable-next-line: assign-type-mismatch
						delete = "^(..)().-(.)()$",
						change = {
							---@diagnostic disable-next-line: assign-type-mismatch
							target = "(%${)()[^}]*(})()",
						},
					},
					["D"] = {
						---@diagnostic disable-next-line: assign-type-mismatch
						add = { '"${', '}"' },
						find = function()
							return require("nvim-surround.config").get_selection({ pattern = '"%${[^}]*}"' })
						end,
						---@diagnostic disable-next-line: assign-type-mismatch
						delete = "^(...)().-(..)()$",
						change = {
							---@diagnostic disable-next-line: assign-type-mismatch
							target = '("%${)()[^}]*(}")()',
						},
					},
					-- XXX this one is not working properly (delete/change edits parentheses only)
					["s"] = {
						---@diagnostic disable-next-line: assign-type-mismatch
						add = { "$(", ")" },
						find = function()
							return require("nvim-surround.config").get_selection({ pattern = "%$%([^)]*%)" })
						end,
						---@diagnostic disable-next-line: assign-type-mismatch
						delete = "^(..)().-(.)()$",
						change = {
							---@diagnostic disable-next-line: assign-type-mismatch
							target = "^(%$%())()[^)]*(%))()$",
						},
					},
					["S"] = {
						---@diagnostic disable-next-line: assign-type-mismatch
						add = { '"$(', ')"' },
						find = function()
							return require("nvim-surround.config").get_selection({ pattern = '"%$%([^)]*%)"' })
						end,
						---@diagnostic disable-next-line: assign-type-mismatch
						delete = "^(...)().-(..)()$",
						change = {
							---@diagnostic disable-next-line: assign-type-mismatch
							target = '^("%$%()()[^)]*(%)")()$',
						},
					},
				},
			})
		end,
	},
	{
		"windwp/nvim-autopairs",
		config = function()
			local ap = require("nvim-autopairs")
			local Rule = require("nvim-autopairs.rule")
			ap.setup({
				map_c_h = true,
				map_c_w = true,
				fast_wrap = {
					map = "<M-p>",
					keys = "asdfghjklqwertyuiopzxcvbnm",
					end_keys = ";",
				},
			})
			ap.remove_rule("'")
			ap.add_rules({
				Rule("<", ">", { "rust" }),
				Rule("'", "'", { "-rust" }),
			})
		end,
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
			})
			vim.keymap.set("n", "gS", "<Cmd>TSJToggle<CR>")
		end,
	},
}
