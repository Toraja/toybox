return {
	{
		"ggandor/leap.nvim",
		dependencies = {
			{ "ggandor/flit.nvim" },
		},
		config = function()
			local direction_forward = "forward"
			local direction_backward = "backward"
			local function get_jump_targets(opts)
				opts = opts or {}

				local wininfo = vim.fn.getwininfo(opts.winid)[1]
				local cur_line = vim.fn.line(".")
				local cur_col = vim.fn.col(".")

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
						local cnum = math.min(cur_col, string.len(vim.fn.getline(lnum)))
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
			--   function() require('leap').leap { target_windows = { vim.fn.win_getid() } } end)
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
				mode = { "n" },
			},
			{
				"S",
				function()
					require("pounce").pounce({ do_repeat = true })
				end,
				mode = { "n" },
			},
			{
				"s",
				function()
					require("pounce").pounce({})
				end,
				mode = { "x" },
			},
			{
				"s",
				function()
					require("pounce").pounce({})
				end,
				mode = { "o" },
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
				next_repeat = "<C-n><C-n>",
				prev_repeat = "<C-p><C-p>",
				operators = {
					["<C-d>"] = {
						next = { command = vim.diagnostic.goto_next, desc = "Next diagnostic" },
						prev = { command = vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
						mode = { "n", "v", "o" },
					},
					["<C-l>"] = {
						next = { command = "lnext", desc = "Next loclist item" },
						prev = { command = "lprevious", desc = "Prev loclist item" },
					},
					["<C-q>"] = {
						next = { command = "cnext", desc = "Next quickfix item" },
						prev = { command = "cprevious", desc = "Prev quickfix item" },
					},
				},
			})
		end,
	},
	{
		"chrisgrieser/nvim-spider",
		config = function()
			require("spider").setup({
				skipInsignificantPunctuation = false,
			})
			vim.keymap.set(
				{ "n", "o", "x" },
				"<M-w>",
				"<Cmd>lua require('spider').motion('w')<CR>",
				{ desc = "Spider-w" }
			)
			-- vim.keymap.set({ "n", "o", "x" }, "<M-e>", "<Cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
			vim.keymap.set(
				{ "n", "o", "x" },
				"<M-b>",
				"<Cmd>lua require('spider').motion('b')<CR>",
				{ desc = "Spider-b" }
			)
			-- vim.keymap.set({ "n", "o", "x" }, "<M-g><M-e>", "<Cmd>lua require('spider').motion('ge')<CR>",
			--   { desc = "Spider-ge" })
		end,
	},
	{
		"chrisgrieser/nvim-various-textobjs",
		config = function()
			require("various-textobjs").setup({
				lookForwardLines = 0, -- set to 0 to only look in the current line
			})
			vim.keymap.set(
				{ "o", "x" },
				"ii",
				'<Cmd>lua require("various-textobjs").indentation(true, true)<CR>',
				{ desc = "An indentation block" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"ai",
				'<Cmd>lua require("various-textobjs").indentation(false, true)<CR>',
				{ desc = "An indentation block + line above" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"iI",
				'<Cmd>lua require("various-textobjs").indentation(true, false)<CR>',
				{ desc = "An indentation block + line below" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"aI",
				'<Cmd>lua require("various-textobjs").indentation(false, false)<CR>',
				{ desc = "An indentation block + line above/below" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"im",
				'<Cmd>lua require("various-textobjs").subword(true)<CR>',
				{ desc = "Subword (inner)" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"am",
				'<Cmd>lua require("various-textobjs").subword(false)<CR>',
				{ desc = "Subword (outer)" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"gG",
				'<Cmd>lua require("various-textobjs").entireBuffer()<CR>',
				{ desc = "Entire buffer" }
			)
			vim.keymap.set(
				{ "o" },
				"u",
				'<Cmd>lua require("various-textobjs").lineCharacterwise()<CR>',
				{ desc = "Whole line without indent" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"gl",
				"<Cmd>lua require('various-textobjs').nearEoL()<CR>",
				{ desc = "To EoL - 1" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"iv",
				'<Cmd>lua require("various-textobjs").value(true)<CR>',
				{ desc = "Value of key-value pair (inner)" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"av",
				'<Cmd>lua require("various-textobjs").value(false)<CR>',
				{ desc = "Value of key-value pair (outer)" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"ik",
				'<Cmd>lua require("various-textobjs").key(true)<CR>',
				{ desc = "Key of key-value pair (inner)" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"ak",
				'<Cmd>lua require("various-textobjs").key(false)<CR>',
				{ desc = "Key of key-value pair (outer)" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"ie",
				'<Cmd> lua require("various-textobjs").chainMember(true) <CR>',
				{ desc = "Chain member (inner)" }
			)
			vim.keymap.set(
				{ "o", "x" },
				"ae",
				'<Cmd>lua require("various-textobjs").chainMember(false)<CR>',
				{ desc = "Chain member (outer)" }
			)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
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
							["as"] = "@class.outer",
							["is"] = "@class.inner",
							["at"] = "@statement.outer",
							["it"] = "@statement.inner",
							["aT"] = "@attribute.outer",
							["iT"] = "@attribute.inner",
							["ax"] = "@regex.outer",
							["ix"] = "@regex.inner",
						},
					},
				},
			})
		end,
	},
}