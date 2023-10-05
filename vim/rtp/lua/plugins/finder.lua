return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-telescope/telescope-ghq.nvim" },
			{ "LinArcX/telescope-scriptnames.nvim" },
			{ "brookhong/telescope-pathogen.nvim" },
			{ "princejoogie/dir-telescope.nvim" },
			{ "tsakirist/telescope-lazy.nvim" },
			{ "benfowler/telescope-luasnip.nvim" },
		},
		config = function()
			-- Add line number to preview
			vim.api.nvim_create_autocmd({ "User" }, {
				group = vim.api.nvim_create_augroup("my_telescope", {}),
				pattern = "TelescopePreviewerLoaded",
				callback = function()
					vim.opt_local.number = true
				end,
			})

			local telescope = require("telescope")
			local action = require("telescope.actions")
			local action_set = require("telescope.actions.set")
			local action_layout = require("telescope.actions.layout")
			local function bottom_pane_borderchars()
				return {
					prompt = { "─", "│", " ", "│", "╭", "╮", "", " " },
					preview = { "─", "│", "─", "│", "╭", "│", "╯", "─" },
					results = { " ", " ", "─", "│", " ", " ", "─", "╰" },
				}
			end
			telescope.setup({
				defaults = {
					vimgrep_arguments = {
						"rg",
						"--color=never",
						"--no-heading",
						"--with-filename",
						"--line-number",
						"--column",
						"--smart-case",
						"--hidden",
						"--glob",
						"!.git",
					},
					sorting_strategy = "ascending",
					-- wrap_results = true,
					path_display = { truncate = 1 },
					layout_strategy = "bottom_pane",
					borderchars = bottom_pane_borderchars(),
					layout_config = {
						horizontal = {
							width = 0.95,
							height = 0.95,
							prompt_position = "top",
							preview_width = 0.60,
						},
						bottom_pane = {
							height = 0.99,
							preview_width = 0.60,
						},
						vertical = {
							width = 0.92,
							height = 0.92,
							preview_width = 0.60,
						},
					},
					mappings = {
						n = {
							q = action.close,
							["<C-d>"] = function(bufnr)
								action_set.scroll_results(bufnr, 1)
							end,
							["<C-u>"] = function(bufnr)
								action_set.scroll_results(bufnr, 0)
							end,
							["<M-j>"] = function(bufnr)
								action_set.scroll_previewer(bufnr, 1)
							end,
							["<M-k>"] = function(bufnr)
								action_set.scroll_previewer(bufnr, 0)
							end,
						},
						i = {
							["<Esc>"] = action.close,
							["<C-\\>"] = { "<Esc>", type = "command" },
							["<C-_>"] = action_layout.toggle_preview,
							["<Tab>"] = action.move_selection_worse,
							["<C-j>"] = function(bufnr)
								action.toggle_selection(bufnr)
								action.move_selection_worse(bufnr)
							end,
							["<C-M-j>"] = function(bufnr)
								action.toggle_selection(bufnr)
								action.move_selection_better(bufnr)
							end,
							["<M-<>"] = action.move_to_top,
							["<M->>"] = action.move_to_bottom,
							["<C-d>"] = { "<DEL>", type = "command" },
							["<C-u>"] = { "<C-u>", type = "command" },
							["<M-j>"] = function(bufnr)
								action_set.scroll_previewer(bufnr, 0.5)
							end,
							["<M-k>"] = function(bufnr)
								action_set.scroll_previewer(bufnr, -0.5)
							end,
							["<C-M-n>"] = action.cycle_history_next,
							["<C-M-p>"] = action.cycle_history_prev,
							["<M-?>"] = action.which_key,
						},
					},
				},
				pickers = {
					-- Default configuration for builtin pickers goes here:
					find_files = {
						find_command = { "fd", "--hidden", "--exclude", ".git" },
					},
					oldfiles = {
						layout_config = { preview_width = 0.5 },
					},
					live_grep = {
						layout_config = { preview_width = 0.5 },
					},
					grep_string = {
						layout_config = { preview_width = 0.5 },
					},
					-- Now the picker_config_key will be applied every time you call this
					-- builtin picker
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("ghq")
			telescope.load_extension("scriptnames")
			telescope.load_extension("pathogen")
			telescope.load_extension("dir")
			telescope.load_extension("lazy")
			telescope.load_extension("luasnip")
			require("dir-telescope").setup({
				no_ignore = true,
			})

			require("keymap.which-key-helper").register_with_editable(
				"Telescope",
				vim.g.chief_key .. "f",
				vim.g.chief_key,
				{
					b = { 'lua require("telescope.builtin").buffers()', { desc = "Buffers" } },
					c = { 'lua require("telescope.builtin").git_bcommits()', { desc = "Git buffer commits" } },
					C = { 'lua require("telescope.builtin").git_commits()', { desc = "Git commits" } },
					d = { 'lua require("telescope.builtin").diagnostics()', { desc = "Diagnostics" } },
					e = {
						'lua require("pathogen").browse_file({ cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })',
						{ desc = "File browser" },
					},
					f = { 'lua require("pathogen").find_files()', { desc = "Files" } },
					g = { 'lua require("telescope.builtin").git_status()', { desc = "Git status" } },
					G = { 'lua require("telescope.builtin").git_files()', { desc = "Git files" } },
					h = { 'lua require("telescope.builtin").help_tags()', { desc = "Help tags" } },
					H = { 'lua require("telescope.builtin").highlights()', { desc = "Highlights" } },
					k = { 'lua require("telescope.builtin").keymaps()', { desc = "Keymaps" } },
					l = {
						'lua require("telescope.builtin").current_buffer_fuzzy_find()',
						{ desc = "Buffer lines" },
					},
					m = { 'lua require("telescope.builtin").marks()', { desc = "Marks" } },
					n = { 'lua require("telescope").extensions.notify.notify()', { desc = "Notify" } },
					o = { 'lua require("telescope.builtin").treesitter()', { desc = "Treesitter" } },
					O = { 'lua require("telescope.builtin").oldfiles()', { desc = "Oldfiles" } },
					p = { 'lua require("telescope").extensions.lazy.lazy()', { desc = "Lazy" } },
					P = { 'lua require("telescope.builtin").spell_suggest()', { desc = "Spell suggest" } },
					q = {
						'lua require("telescope").extensions.ghq.list({ layout_config = { preview_width = 0.5 } })',
						{ desc = "Ghq list" },
					},
					r = { 'lua require("pathogen").live_grep()', { desc = "Grep" } },
					R = {
						'lua require("telescope").extensions.dir.live_grep()',
						{ desc = "Pick directory + Grep" },
					},
					s = {
						'lua require("telescope").extensions.luasnip.luasnip()',
						{ desc = "Scriptnames" },
					},
					S = {
						'lua require("telescope").extensions.scriptnames.scriptnames()',
						{ desc = "Scriptnames" },
					},
					t = { "Greyjoy", { desc = "Greyjoy" } },
					y = {
						'lua require("telescope").extensions.yank_history.yank_history()',
						{ desc = "Yank history" },
					},
					[":"] = { 'lua require("telescope.builtin").command_history()', { desc = "Command history" } },
					["/"] = { 'lua require("telescope.builtin").search_history()', { desc = "Search history" } },
				}
			)
		end,
		-- Not lazy loading as other plugins load it anyway
		-- keys = {
		-- 	{
		-- 		vim.g.chief_key .. "f",
		-- 		"<Cmd>WhichKey " .. vim.g.chief_key .. "f n<CR>",
		-- 		mode = { "n" },
		-- 		desc = "Telescope",
		-- 	},
		-- },
	},
}
