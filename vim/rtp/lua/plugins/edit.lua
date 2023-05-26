return {
	"tpope/vim-repeat",
	{
		"tpope/vim-abolish",
		init = function()
			vim.g.abolish_no_mappings = 1
		end,
		cmd = { "Abolish", "Subvert" },
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
		end,
		keys = {
			{ "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" } },
			{ "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" } },
			{ "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" } },
			{ "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" } },
			{ "<M-p>", "<Plug>(YankyCycleForward)", mode = { "n" } },
			{ "<M-P>", "<Plug>(YankyCycleBackward)", mode = { "n" } },
		},
	},
	{
		"numToStr/Comment.nvim",
		config = function()
			local ft = require("Comment.ft")
			require("Comment").setup({
				ignore = "^$",
				ft.set("asciidoc", { "//%s", "////%s////" }),
			})
			vim.keymap.set(
				"i",
				"<C-\\>",
				'<Cmd>lua require("Comment.api").toggle.linewise.count(1)<CR>',
				{ silent = true }
			)
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
				on_substitute = require("yanky.integration").substitute(),
			})
		end,
		keys = {
			{
				"cp",
				'<Cmd>lua require("substitute").operator()<CR>',
				mode = { "n" },
				desc = "Replace operator text with yanked text",
			},
			{
				"cpp",
				'<Cmd>lua require("substitute").operator({ motion = "iw" })<CR>',
				mode = { "n" },
				desc = "Replace operator text with yanked text",
			},
			{
				"cp",
				'<Cmd>lua require("substitute").visual()<CR>',
				mode = { "x" },
				desc = "Replace visual text with yanked text",
			},
			{
				"<Leader>c",
				'<Cmd>lua require("substitute.range").operator()<CR>',
				mode = { "n" },
				desc = "Substitute operator text within the range",
			},
			{
				"<Leader>c",
				'<Cmd>lua require("substitute.range").visual()<CR>',
				mode = { "x" },
				desc = "Substitute visual text within the range",
			},
			{
				"<Leader>cc",
				'<Cmd>lua require("substitute.range").operator({ motion1 = "iw" })<CR>',
				mode = { "n" },
				desc = "Substitute cursor word within the range",
			},
			{
				"cx",
				'<Cmd>lua require("substitute.exchange").operator()<CR>',
				mode = { "n" },
				desc = "Swap operator text",
			},
			{
				"cxx",
				'<Cmd>lua require("substitute.exchange").operator({ motion = "iw" })<CR>',
				mode = { "n" },
				desc = "Swap cursor word",
			},
			{
				"X",
				'<Cmd>lua require("substitute.exchange").visual()<CR>',
				mode = { "x" },
				desc = "Swap visual text",
			},
			{
				"cxc",
				'<Cmd>lua require("substitute.exchange").cancel()<CR>',
				mode = { "n" },
				desc = "Cancel swapping text",
			},
		},
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
		-- With keys property, these mapping is not registered as group mapping.
		-- keys = {
		-- 	{ "ga", "<Cmd>WhichKey ga n<CR>", mode = { "n" }, desc = "text-case" },
		-- 	{ "gao", "<Cmd>WhichKey gao n<CR>", mode = { "n" }, desc = "Pending mode operator" },
		-- 	{ "ga", "<Cmd>WhichKey ga v<CR>", mode = { "v" }, desc = "text-case" },
		-- },
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
		end,
		keys = {
			{ "gS", "<Cmd>TSJToggle<CR>", mode = { "n" }, desc = "TreeSJ Toggle" },
		},
	},
}
