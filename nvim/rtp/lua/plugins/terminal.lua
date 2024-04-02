local joshuto_output_file_path = "/tmp/joshuto_filechosen"
return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local shell = "fish"
			require("toggleterm").setup({
				open_mapping = [[<M-\>]],
				on_create = function()
					vim.opt_local.signcolumn = "no"
				end,
				on_open = function(term)
					if not term:is_float() then
						-- NOTE: setting tab variable has to be in `on_open`  instead of `on_create`
						-- or tab variable will disappear when toggleterm is reopened.
						require("tab").set_tab_name(0, vim.split(term.name, ";#")[2])
					end
					vim.cmd([[
								startinsert
								]])
				end,
				-- Do not set autochdir to `true` as it is dangerous.
				-- The way toggleterm changes directory is inserting `cd /dir/to/change<CR>` to command line
				-- so if command line buffer is not empty, not only changing directory fails, but also a command
				-- is executed unexpectedly.
				autochdir = false,
				direction = "tab",
				shell = shell,
			})
		end,
		keys = {
			{ "<M-Bslash>", "<M-Bslash>", mode = { "n" }, desc = "Toggle Terminal" },
			{
				"<Leader>v",
				function()
					-- Terminal:new() must be called everytime, or the cwd is not updated
					-- and the cwd at which vim is started is used instead.
					require("toggleterm.terminal").Terminal
						:new({
							cmd = "lazygit",
							direction = "float",
							float_opts = {
								width = math.floor(vim.o.columns * 0.95),
								height = math.floor(vim.o.lines - 6),
							},
						})
						:toggle()
				end,
				mode = { "n" },
				desc = "lazygit",
			},
			{
				"<Leader>e",
				function()
					require("toggleterm.terminal").Terminal
						:new({
							cmd = string.format(
								"joshuto --file-chooser --output-file '%s' '%s'",
								joshuto_output_file_path,
								vim.fn.expand("%:p:h")
							),
							direction = "float",
							float_opts = {
								width = math.floor(vim.o.columns * 0.95),
								height = math.floor(vim.o.lines - 6),
							},
							on_exit = function(_, _, exit_code, _)
								if exit_code ~= 102 then
									return
								end
								local chosen_file = vim.fn.readfile(joshuto_output_file_path)[1]
								if chosen_file then
									vim.cmd(string.format("tabedit %s", chosen_file))
								end
							end,
						})
						:toggle()
				end,
				mode = { "n" },
				desc = "joshuto",
			},
		},
	},
	{
		"ryanmsnyder/toggleterm-manager.nvim",
		enabled = false,
		dependencies = {
			"akinsho/toggleterm.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local toggleterm_manager = require("toggleterm-manager")
			local actions = toggleterm_manager.actions
			toggleterm_manager.setup({
				mappings = {
					i = {
						["<CR>"] = { action = actions.open_term, exit_on_action = true },
						["<C-i>"] = { action = actions.create_and_name_term, exit_on_action = false },
						["<C-o>"] = { action = actions.create_term, exit_on_action = false },
						["<C-Space>"] = { action = actions.toggle_term, exit_on_action = false },
					},
				},
			})
		end,
	},
	{
		"willothy/flatten.nvim",
		-- Commands that open editor (such as git rebase -i) do not work properly as when flatten.nvim opens vim in outer instance,
		-- those command detect editor being closed without any edit and move to next step.
		enabled = false,
		opts = {
			window = {
				open = "tab",
			},
		},
	},
}
