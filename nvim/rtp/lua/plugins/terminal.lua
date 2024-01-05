return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local shell = "fish"
			require("toggleterm").setup({
				open_mapping = [[<C-\>]],
				on_create = function()
					vim.opt_local.signcolumn = "no"
				end,
				on_open = function(term)
					if term.direction ~= "float" then
						-- NOTE: skip setting tab name when float window to avoid tab name for terminal
						-- remaining even after the terminal is closed
						-- NOTE: setting tab variable has to be in `on_open`  instead of `on_create`
						-- or tab variable will disappear when toggleterm is reopened.
						require("tab").set_tab_name(0, vim.split(term.name, ";#")[2])
					end
					vim.cmd([[
								startinsert
								]])
				end,
				autochdir = true, -- when neovim changes it current directory the terminal will change it's own when next it's opened
				direction = "tab",
				shell = shell,
			})
			local lazygit = require("toggleterm.terminal").Terminal:new({
				cmd = "lazygit",
				direction = "float",
				float_opts = {
					width = math.floor(vim.o.columns * 0.95),
					height = math.floor(vim.o.lines - 6),
				},
				on_create = function(term)
					vim.api.nvim_buf_set_name(term.bufnr, "lazygit")
				end,
			})
			vim.keymap.set("n", "<Leader>v", function()
				lazygit:toggle()
			end, { desc = "lazygit" })
		end,
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
