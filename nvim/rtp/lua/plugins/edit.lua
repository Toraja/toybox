vim.g.nvim_surround_no_mappings = true

return {
	{
		"L3MON4D3/LuaSnip",
		version = "*",
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			local node_util = require("luasnip.nodes.util")

			require("luasnip").config.setup({
				store_selection_keys = "<C-]>",
				-- By default, when a placeholder has nested placeholders, the enclosing placeholder is not visually selected (i.e., the cursor is placed at the beginning of the placeholder without highlight).
				-- This function modifies that and highlights the enclosing placeholder as well.
				-- https://github.com/L3MON4D3/LuaSnip/wiki/Nice-Configs#imitate-vscodes-behaviour-for-nested-placeholders
				parser_nested_assembler = function(_, snippetNode)
					local select = function(snip, no_move, dry_run)
						if dry_run then
							return
						end
						snip:focus()
						-- make sure the inner nodes will all shift to one side when the
						-- entire text is replaced.
						snip:subtree_set_rgrav(true)
						-- fix own extmark-gravities, subtree_set_rgrav affects them as well.
						snip.mark:set_rgravs(false, true)

						-- SELECT all text inside the snippet.
						if not no_move then
							require("luasnip.util.feedkeys").feedkeys_insert("<Esc>")
							node_util.select_node(snip)
						end
					end

					local original_extmarks_valid = snippetNode.extmarks_valid
					function snippetNode:extmarks_valid()
						-- the contents of this snippetNode are supposed to be deleted, and
						-- we don't want the snippet to be considered invalid because of
						-- that -> always return true.
						return true
					end

					function snippetNode:init_dry_run_active(dry_run)
						if dry_run and dry_run.active[self] == nil then
							dry_run.active[self] = self.active
						end
					end

					function snippetNode:is_active(dry_run)
						return (not dry_run and self.active) or (dry_run and dry_run.active[self])
					end

					function snippetNode:jump_into(dir, no_move, dry_run)
						self:init_dry_run_active(dry_run)
						if self:is_active(dry_run) then
							-- inside snippet, but not selected.
							if dir == 1 then
								self:input_leave(no_move, dry_run)
								return self.next:jump_into(dir, no_move, dry_run)
							else
								select(self, no_move, dry_run)
								return self
							end
						else
							-- jumping in from outside snippet.
							self:input_enter(no_move, dry_run)
							if dir == 1 then
								select(self, no_move, dry_run)
								return self
							else
								return self.inner_last:jump_into(dir, no_move, dry_run)
							end
						end
					end

					-- this is called only if the snippet is currently selected.
					function snippetNode:jump_from(dir, no_move, dry_run)
						if dir == 1 then
							if original_extmarks_valid(snippetNode) then
								return self.inner_first:jump_into(dir, no_move, dry_run)
							else
								return self.next:jump_into(dir, no_move, dry_run)
							end
						else
							self:input_leave(no_move, dry_run)
							return self.prev:jump_into(dir, no_move, dry_run)
						end
					end

					return snippetNode
				end,
			})
			local ls_vscode = require("luasnip.loaders.from_vscode")
			ls_vscode.lazy_load() -- load available snippets in runtimepath (friendly-snippets)
			-- The above somehow prioritise friendly-snippets over my own snippets if my own snippets are also stored in runtimepath.
			-- So load my own snippets separately with higher priority to make sure they are used instead of friendly-snippets.
			ls_vscode.lazy_load({ paths = { vim.g.my_snippets_dir }, override_priority = 9999 })

			vim.keymap.set({ "i", "s" }, "<C-]>", "<Plug>luasnip-expand-or-jump")
			vim.keymap.set({ "i", "s" }, "<M-C-]>", "<Plug>luasnip-jump-prev")
			-- vim.keymap.set({ "i", "s" }, "<C-s>", "<Plug>luasnip-jump-next")
			-- vim.keymap.set({ "i", "s" }, "<M-s>", "<Plug>luasnip-jump-prev")
			vim.keymap.set("s", "<Tab>", "<Esc>i", { noremap = true })
			vim.keymap.set("s", "<C-a>", "<Esc>a", { noremap = true })

			vim.api.nvim_create_user_command("LuaSnipLoadSnippetsVSCode", ls_vscode.load, {})
		end,
		event = "InsertEnter",
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
		enabled = false,
		config = function()
			local ft = require("Comment.ft")
			ft.set("asciidoc", { "//%s", "////%s////" })
			require("Comment").setup({
				ignore = "^$",
				toggler = { line = "glc", block = "gbc" },
				opleader = { line = "gl", block = "gb" },
				extra = { above = "glO", below = "glo", eol = "glA" },
			})
		end,
		keys = {
			{ "gl", "gl", mode = { "n", "x" } },
			{ "gb", "gb", mode = { "n", "x" } },
			{ "<C-l>", "<Cmd>lua require('Comment.api').toggle.linewise.count(1)<CR>", mode = { "i" } },
			{
				"gyl",
				"yy<Plug>(comment_toggle_linewise_current)",
				mode = { "n" },
				desc = "Yank and comment linewise",
			},
			{
				"gyl",
				"ygv<Plug>(comment_toggle_linewise_visual)",
				mode = { "x" },
				desc = "Yank and comment linewise",
			},
		},
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
			-- This is vim's builtin functionality
			-- {
			-- 	"P",
			-- 	'<Cmd>lua require("substitute").visual()<CR>',
			-- 	mode = { "x" },
			-- 	desc = "Replace visual text with yanked text",
			-- },
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
				"<Leader>C",
				'<Cmd>lua require("substitute.range").visual({ range = "%" })<CR>',
				mode = { "x" },
				desc = "Substitute visual text in the entire buffer",
			},
			{
				"<Leader>co",
				'<Cmd>lua require("substitute.range").operator({ subject = { motion = "iw" } })<CR>',
				mode = { "n" },
				desc = "Substitute cursor word within the range",
			},
			{
				"<Leader>cc",
				'<Cmd>lua require("substitute.range").operator({ subject = { motion = "iw" }, range = "%" })<CR>',
				mode = { "n" },
				desc = "Substitute cursor word in the entire buffer",
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
					-- quick_replace = key,
					operator = key,
					visual = key,
				})
			end
		end,
		keys = {
			{ "ga", mode = { "n", "v" }, desc = "text-case" },
		},
	},
	{
		"kylechui/nvim-surround",
		version = "*", -- Use for stability; omit to use `main` branch for the latest features
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-surround").setup({
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
					["v"] = {
						---@diagnostic disable-next-line: assign-type-mismatch
						add = { "{{ ", " }}" },
						find = function()
							return require("nvim-surround.config").get_selection({ pattern = "{{ [^}] }}" })
						end,
						---@diagnostic disable-next-line: assign-type-mismatch
						delete = "^({{ )()[^}]*( }})()$",
						change = {
							---@diagnostic disable-next-line: assign-type-mismatch
							target = "^({{ }})()[^}]*( }})()$",
						},
					},
				},
			})

			vim.keymap.set("n", "yr", "<Plug>(nvim-surround-normal)", {
				desc = "Add a surrounding pair around a motion (normal mode)",
			})
			vim.keymap.set("n", "yrr", "<Plug>(nvim-surround-normal-cur)", {
				desc = "Add a surrounding pair around the current line (normal mode)",
			})
			vim.keymap.set("n", "yR", "<Plug>(nvim-surround-normal-line)", {
				desc = "Add a surrounding pair around a motion, on new lines (normal mode)",
			})
			vim.keymap.set("n", "yRR", "<Plug>(nvim-surround-normal-cur-line)", {
				desc = "Add a surrounding pair around the current line, on new lines (normal mode)",
			})
			vim.keymap.set("x", "R", "<Plug>(nvim-surround-visual)", {
				desc = "Add a surrounding pair around a visual selection",
			})
			vim.keymap.set("x", "gR", "<Plug>(nvim-surround-visual-line)", {
				desc = "Add a surrounding pair around a visual selection, on new lines",
			})
			vim.keymap.set("n", "dr", "<Plug>(nvim-surround-delete)", {
				desc = "Delete a surrounding pair",
			})
			vim.keymap.set("n", "cr", "<Plug>(nvim-surround-change)", {
				desc = "Change a surrounding pair",
			})
			vim.keymap.set("n", "cR", "<Plug>(nvim-surround-change-line)", {
				desc = "Change a surrounding pair, putting replacements on new lines",
			})
		end,
		event = "VeryLazy",
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
					map = "<M-r>",
					keys = "asdfghjklqwertyuiopzxcvbnm",
					end_key = ";",
					manual_position = false, -- true requires extra key press to choose before/after the posision
					use_virt_lines = false, -- highlight position is not right if indented with tabs
				},
			})
			ap.remove_rule("'")
			ap.add_rules({
				Rule("<", ">", { "rust" }),
				Rule("'", "'", { "-rust" }),
			})
		end,
		event = "InsertEnter",
	},
	{
		"Wansmer/treesj",
		dependencies = { "nvim-treesitter" },
		config = function()
			require("treesj").setup({
				use_default_keymaps = false,
				max_join_length = 200,
			})
		end,
		keys = {
			{ "gJ", "<Cmd>TSJJoin<CR>", mode = { "n" }, desc = "TreeSJ join" },
			{ "gS", "<Cmd>TSJSplit<CR>", mode = { "n" }, desc = "TreeSJ split" },
		},
	},
}
