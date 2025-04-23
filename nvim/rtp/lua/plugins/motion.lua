local flash_line_jump_option = {
	search = {
		mode = "search",
		max_length = 0,
		wrap = false,
		multi_window = false,
	},
	label = { before = false, after = { 0, 0 }, uppercase = true },
	action = function(match)
		-- force linewise when operator mode
		if vim.api.nvim_get_mode().mode == "no" then
			local current_line_num, _ = unpack(vim.api.nvim_win_get_cursor(match.win))
			vim.api.nvim_win_set_cursor(match.win, { current_line_num, 0 })
			vim.cmd("normal! V")
		end

		-- this is taken from flash.nvim help
		vim.api.nvim_win_call(match.win, function()
			vim.api.nvim_win_set_cursor(match.win, match.pos)
		end)
	end,
	pattern = "^",
}
local flash_line_jump_down_option =
	vim.tbl_deep_extend("force", flash_line_jump_option, { search = { forward = true } })
local flash_line_jump_up_option = vim.tbl_deep_extend("force", flash_line_jump_option, { search = { forward = false } })

return {
	{
		"folke/flash.nvim",
		dependencies = {
			{ "folke/which-key.nvim" },
		},
		config = function()
			local flash_util = require("flash.util")
			flash_util.BS = flash_util.t("<C-h>")

			require("flash").setup({
				search = {
					-- multi_window = false,
					-- mode = "search", -- seems same as exact?
					-- mode = "fuzzy", -- too fuzzy and cannot point to where I want
				},
				label = {
					uppercase = false,
					after = false,
					-- The label is placed next to the match by default, and if indent is tab char,
					-- the label and actual match is very far. This places the labels exactly on the match.
					before = { 0, 0 },
					rainbow = {
						enabled = true,
						-- number between 1 and 9
						shade = 5,
					},
				},
				highlight = {
					groups = {
						match = "FlashCurrent",
						current = "Search",
						label = "Type",
					},
				},
				modes = {
					search = {
						enabled = false,
					},
					char = {
						jump_labels = true,
						jump = {
							autojump = true,
						},
						multi_line = false,
						label = { after = { 0, 0 } },
					},
					treesitter = {
						label = { before = { 0, 0 }, after = { 0, 0 } },
					},
					treesitter_search = {
						label = { before = { 0, 0 }, after = { 0, 0 } },
					},
				},
			})
		end,
		keys = {
			{
				"s",
				function()
					require("flash").jump()
				end,
				mode = { "n", "x", "o" },
				desc = "Flash",
			},
			{
				"S",
				function()
					require("flash").jump({ continue = true })
				end,
				mode = { "n", "x", "o" },
				desc = "Flash Continue Last",
			},
			{
				"gs",
				function()
					require("flash").remote()
				end,
				mode = "o",
				desc = "Flash Remote",
			},
			{
				"<Leader>s",
				function()
					require("flash").treesitter()
				end,
				mode = { "n", "x", "o" },
				desc = "Flash Treesitter",
			},
			{
				"<Leader>S",
				function()
					require("flash").treesitter_search()
				end,
				mode = { "n", "o" },
				desc = "Flash Treesitter Search",
			},
			{
				"<c-s>",
				function()
					require("flash").toggle()
				end,
				mode = { "c" },
				desc = "Toggle Flash Search",
			},
			{
				"gj",
				function()
					require("flash").jump(flash_line_jump_down_option)
				end,
				mode = { "n", "x", "o" },
				desc = "Line jump downward",
			},
			{
				"gk",
				function()
					require("flash").jump(flash_line_jump_up_option)
				end,
				mode = { "n", "x", "o" },
				desc = "Line jump upward",
			},
			-- Map each key to itself so that these key is bound to keymap set by the plugin
			{
				"f",
				"f",
				mode = { "n", "x", "o" },
				desc = "Move to char forward",
			},
			{
				"F",
				"F",
				mode = { "n", "x", "o" },
				desc = "Move to char backward",
			},
			{
				"t",
				"t",
				mode = { "n", "x", "o" },
				desc = "Move before char forward",
			},
			{
				"T",
				"T",
				mode = { "n", "x", "o" },
				desc = "Move before char backward",
			},
		},
	},
	{
		"ggandor/leap.nvim",
		enabled = false,
		dependencies = {
			{ "ggandor/flit.nvim" },
		},
		config = function()
			local direction_forward = "forward"
			local direction_backward = "backward"
			local function get_jump_targets(opts)
				opts = opts or {}

				local wininfo = vim.fn.getwininfo(opts.winid)[1]
				-- local cur_line = vim.fn.line(".")
				-- local cur_col = vim.fn.col(".")
				local cur_line, cur_col = unpack(vim.api.nvim_win_get_cursor(0))

				local function get_start_end_lnum()
					-- if opts.direction == 'forward' then
					if opts.direction == direction_forward then
						return cur_line, wininfo.botline
					end

					if opts.direction == direction_backward then
						return wininfo.topline, cur_line
					end

					return wininfo.topline, wininfo.botline
				end

				-- Get targets.
				local targets = {}
				local start_lnum, end_lnum = get_start_end_lnum()
				local lnum = start_lnum
				while lnum <= end_lnum do
					local fold_end = vim.fn.foldclosedend(lnum)
					-- Skip folded ranges.
					if fold_end ~= -1 then
						lnum = fold_end + 1
					else
						local cnum =
							math.min(cur_col, string.len(vim.api.nvim_buf_get_lines(0, lnum - 1, lnum, false)[1]))
						if lnum ~= cur_line then
							table.insert(targets, { pos = { lnum, cnum } })
						end
						lnum = lnum + 1
					end
				end
				-- Sort them by vertical screen distance from cursor.
				local cur_screen_row = vim.fn.screenpos(opts.winid, cur_line, 1)["row"]
				local function screen_rows_from_cur(t)
					local t_screen_row = vim.fn.screenpos(opts.winid, t.pos[1], t.pos[2])["row"]
					return math.abs(cur_screen_row - t_screen_row)
				end
				table.sort(targets, function(t1, t2)
					return screen_rows_from_cur(t1) < screen_rows_from_cur(t2)
				end)

				if #targets >= 1 then
					return targets
				end
			end

			local function leap_to_line(opts)
				opts = opts or {}
				local winid = vim.api.nvim_get_current_win()
				opts.winid = winid

				local leap_opts = {}
				if opts.direction == nil then
					leap_opts.target_windows = { winid }
				elseif opts.direction == direction_backward then
					leap_opts.backward = true
				end
				leap_opts.targets = get_jump_targets(opts)

				require("leap").leap(leap_opts)
			end

			require("leap").opts.max_phase_one_targets = 0
			require("leap").opts.safe_labels = { "s", "f", "n", "u", "t", "w", "b", "e", "o" }
			require("leap").opts.labels = {
				"s",
				"f",
				"n",
				"j",
				"k",
				"l",
				"h",
				"o",
				"d",
				"w",
				"e",
				"m",
				"b",
				"u",
				"y",
				"v",
				"r",
				"g",
				"t",
				"c",
				"x",
				"z",
			}

			vim.keymap.set({ "n", "x", "o" }, "<Plug>(leap-forward-line)", function()
				leap_to_line({ direction = direction_forward })
			end)
			vim.keymap.set({ "n", "x", "o" }, "<Plug>(leap-backward-line)", function()
				leap_to_line({ direction = direction_backward })
			end)

			-- vim.keymap.set({ 'n', 'x', 'o' }, 's',
			--   function() require('leap').leap { target_windows = { vim.api.nvim_get_current_win() } } end)
			-- vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward-to)')
			-- vim.keymap.set({ 'n', 'x', 'o' }, 'x', '<Plug>(leap-backward-to)')
			vim.keymap.set({ "n", "x" }, "gj", "<Plug>(leap-forward-line)")
			vim.keymap.set({ "n", "x" }, "gk", "<Plug>(leap-backward-line)")
			vim.keymap.set({ "o" }, "gj", "V<Plug>(leap-forward-line)")
			vim.keymap.set({ "o" }, "gk", "V<Plug>(leap-backward-line)")

			require("flit").setup({
				labeled_modes = "nvo",
				multiline = false,
			})
		end,
	},
	{
		"rlane/pounce.nvim",
		enabled = false,
		config = function()
			require("pounce").setup({
				multi_window = false,
			})
		end,
		keys = {
			{
				"s",
				function()
					require("pounce").pounce({})
				end,
				mode = { "n", "x", "o" },
			},
			{
				"S",
				function()
					require("pounce").pounce({ do_repeat = true })
				end,
				mode = { "n", "x", "o" },
			},
		},
	},
	{
		"phaazon/hop.nvim",
		enabled = false,
		config = function()
			local hop = require("hop")
			hop.setup({
				uppercase_labels = true,
			})
			local hop_hint = require("hop.hint")
			local function hop_forward_to()
				hop.hint_char1({
					direction = hop_hint.HintDirection.AFTER_CURSOR,
					current_line_only = true,
					hint_offset = -1,
				})
			end

			local function hop_backward_to()
				hop.hint_char1({
					direction = hop_hint.HintDirection.BEFORE_CURSOR,
					current_line_only = true,
					hint_offset = 1,
				})
			end

			---@diagnostic disable-next-line: unused-local,unused-function
			local function hop_forward_words_end()
				hop.hint_words({
					direction = hop_hint.HintDirection.AFTER_CURSOR,
					hint_position = hop_hint.HintPosition.END,
					current_line_only = true,
				})
			end

			---@diagnostic disable-next-line: unused-local,unused-function
			local function hop_backword_words_end()
				hop.hint_words({
					direction = hop_hint.HintDirection.BEFORE_CURSOR_CURSOR,
					hint_position = hop_hint.HintPosition.END,
					current_line_only = true,
				})
			end

			vim.keymap.set({ "n", "x", "o" }, "f", "<Cmd>HopChar1CurrentLineAC<CR>")
			vim.keymap.set({ "n", "x", "o" }, "F", "<Cmd>HopChar1CurrentLineBC<CR>")
			-- vim.keymap.set({ 'n', 'x', 'o' }, 'sw', "<Cmd>HopWordAC<CR>")
			-- vim.keymap.set({ 'n', 'x', 'o' }, 'sb', "<Cmd>HopWordBC<CR>")
			-- vim.keymap.set({ 'n', 'x', 'o' }, 'se', hop_forward_words_end)
			-- vim.keymap.set({ 'n', 'x', 'o' }, 'sge', hop_backword_words_end)
			vim.keymap.set({ "n", "x" }, "gj", "<Cmd>HopVerticalAC<CR>")
			vim.keymap.set({ "n", "x" }, "gk", "<Cmd>HopVerticalBC<CR>")
			vim.keymap.set("o", "gj", "V<Cmd>HopVerticalAC<CR>")
			vim.keymap.set("o", "gk", "V<Cmd>HopVerticalBC<CR>")
			vim.keymap.set({ "n", "x", "o" }, "s", "<Cmd>HopPatternAC<CR>")
			vim.keymap.set({ "n", "x", "o" }, "<Leader>s", "<Cmd>HopPatternBC<CR>")
			vim.keymap.set("o", "t", hop_forward_to)
			vim.keymap.set("o", "T", hop_backward_to)

			-- repeating is not implemented yet
			-- map s. <Plug>(easymotion-repeat)
			-- map <Bslash> <Plug>(easymotion-next)
			-- map <Bar> <Plug>(easymotion-prev)
		end,
	},
	{
		"liangxianzhe/nap.nvim",
		config = function()
			require("nap").setup({
				next_prefix = "<C-n>",
				prev_prefix = "<C-p>",
				next_repeat = "<C-n><C-n>",
				prev_repeat = "<C-p><C-p>",
				operators = {
					["<C-d>"] = {
						next = {
							rhs = function()
								vim.diagnostic.jump({ count = 1, float = true })
							end,
							opts = { desc = "Next diagnostic" },
						},
						prev = {
							rhs = function()
								vim.diagnostic.jump({ count = -1, float = true })
							end,
							opts = { desc = "Prev diagnostic" },
						},
						mode = { "n", "v", "o" },
					},
					["<C-v>"] = {
						next = { rhs = require("gitsigns").next_hunk, opts = { desc = "Next git hunk" } },
						prev = { rhs = require("gitsigns").prev_hunk, opts = { desc = "Prev git hunk" } },
					},
					["<C-l>"] = {
						next = { rhs = "<cmd>lnext<cr>", opts = { desc = "Next loclist item" } },
						prev = { rhs = "<cmd>lprevious<cr>", opts = { desc = "Prev loclist item" } },
					},
					["<C-q>"] = {
						next = { rhs = "<cmd>cnext<cr>", opts = { desc = "Next quickfix item" } },
						prev = { rhs = "<cmd>cprevious<cr>", opts = { desc = "Prev quickfix item" } },
					},
				},
			})
		end,
		keys = {
			{
				"<C-n>",
				function()
					require("which-key").show({ keys = "<C-n>" })
				end,
				mode = { "n", "v", "o" },
				desc = "nap next",
			},
			{
				"<C-p>",
				function()
					require("which-key").show({ keys = "<C-p>" })
				end,
				mode = { "n", "v", "o" },
				desc = "nap previous",
			},
		},
	},
	{
		"chrisgrieser/nvim-spider",
		config = function()
			require("spider").setup({
				skipInsignificantPunctuation = false,
			})
		end,
		keys = {
			{ "<M-w>", "<Cmd>lua require('spider').motion('w')<CR>", mode = { "n", "o", "x" }, desc = "Spider-w" },
			-- { "<M-e>", "<Cmd>lua require('spider').motion('e')<CR>", mode = { "n", "o", "x" }, desc = "Spider-e" },
			{ "<M-b>", "<Cmd>lua require('spider').motion('b')<CR>", mode = { "n", "o", "x" }, desc = "Spider-b" },
			-- { "<M-g><M-e>", "<Cmd>lua require('spider').motion('ge')<CR>", mode = { "n", "o", "x" }, desc = "Spider-ge" },
		},
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		config = function()
			require("various-textobjs").setup({})
		end,
		keys = {
			{
				"ii",
				'<Cmd>lua require("various-textobjs").indentation("inner", "inner")<CR>',
				mode = { "o", "x" },
				desc = "An indentation block",
			},
			{
				"ai",
				'<Cmd>lua require("various-textobjs").indentation("outer", "inner")<CR>',
				mode = { "o", "x" },
				desc = "An indentation block + line above",
			},
			{
				"iI",
				'<Cmd>lua require("various-textobjs").indentation("inner", "outer")<CR>',
				mode = { "o", "x" },
				desc = "An indentation block + line below",
			},
			{
				"aI",
				'<Cmd>lua require("various-textobjs").indentation("outer", "outer")<CR>',
				mode = { "o", "x" },
				desc = "An indentation block + line above/below",
			},
			{
				"im",
				'<Cmd>lua require("various-textobjs").subword("inner")<CR>',
				mode = { "o", "x" },
				desc = "Subword (inner)",
			},
			{
				"am",
				'<Cmd>lua require("various-textobjs").subword("outer")<CR>',
				mode = { "o", "x" },
				desc = "Subword (outer)",
			},
			{
				"gG",
				'<Cmd>lua require("various-textobjs").entireBuffer()<CR>',
				mode = { "o", "x" },
				desc = "Entire buffer",
			},
			{
				"u",
				'<Cmd>lua require("various-textobjs").lineCharacterwise("inner")<CR>',
				mode = { "o" },
				desc = "Whole line without indent",
			},
			{
				"U",
				'<Cmd>lua require("various-textobjs").lineCharacterwise("outer")<CR>',
				mode = { "o" },
				desc = "Whole line including indent",
			},
			{
				"gL",
				"<Cmd>lua require('various-textobjs').nearEoL()<CR>",
				mode = { "o", "x" },
				desc = "To EoL - 1",
			},
			{
				"iv",
				'<Cmd>lua require("various-textobjs").value("inner")<CR>',
				mode = { "o", "x" },
				desc = "Value of key-value pair (inner)",
			},
			{
				"av",
				'<Cmd>lua require("various-textobjs").value("outer")<CR>',
				mode = { "o", "x" },
				desc = "Value of key-value pair (outer)",
			},
			{
				"ik",
				'<Cmd>lua require("various-textobjs").key("inner")<CR>',
				mode = { "o", "x" },
				desc = "Key of key-value pair (inner)",
			},
			{
				"ak",
				'<Cmd>lua require("various-textobjs").key("outer")<CR>',
				mode = { "o", "x" },
				desc = "Key of key-value pair (outer)",
			},
			{
				"ie",
				'<Cmd> lua require("various-textobjs").chainMember("inner") <CR>',
				mode = { "o", "x" },
				desc = "Chain member (inner)",
			},
			{
				"ae",
				'<Cmd>lua require("various-textobjs").chainMember("outer")<CR>',
				mode = { "o", "x" },
				desc = "Chain member (outer)",
			},
		},
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						keymaps = {
							["aa"] = "@assignment.outer",
							["ia"] = "@assignment.inner",
							["aA"] = "@assignment.rhs",
							["iA"] = "@assignment.lhs",
							["ac"] = "@call.outer",
							["ic"] = "@call.inner",
							["aC"] = "@class.outer",
							["iC"] = "@class.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["aF"] = "@frame.outer",
							["iF"] = "@frame.inner",
							["al"] = "@loop.outer",
							["il"] = "@loop.inner",
							["aM"] = "@comment.outer",
							["iM"] = "@comment.inner",
							["an"] = "@return.outer",
							["in"] = "@return.inner",
							["iN"] = "@number.inner",
							["ao"] = "@block.outer",
							["io"] = "@block.inner",
							["ap"] = "@parameter.outer",
							["ip"] = "@parameter.inner",
							["iP"] = "@scopename.inner",
							["ar"] = "@conditional.outer",
							["ir"] = "@conditional.inner",
							["it"] = "@statement.inner",
							["aT"] = "@attribute.outer",
							["iT"] = "@attribute.inner",
							["ax"] = "@regex.outer",
							["ix"] = "@regex.inner",
						},
						selection_modes = {
							-- v:charwise, V:linewise, <C-v>:blockwise
							["@call.outer"] = "V",
							["@function.outer"] = "V",
							["@loop.outer"] = "V",
							["@comment.outer"] = "V",
							["@conditional.outer"] = "V",
						},
					},
				},
			})
		end,
		event = "VeryLazy",
	},
	{
		"RRethy/nvim-treesitter-textsubjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				textsubjects = {
					enable = true,
					prev_selection = "<Leader>,",
					keymaps = {
						[","] = "textsubjects-smart",
						["+"] = "textsubjects-container-outer",
						["<Leader>+"] = "textsubjects-container-inner",
					},
				},
			})
		end,
		event = "VeryLazy",
	},
}
