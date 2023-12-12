return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				open_mapping = [[<C-\>]],
				on_create = function()
					vim.opt_local.signcolumn = "no"
				end,
				on_open = function(term)
					vim.cmd([[
								startinsert
								]])
					if term.display_name and term.display_name ~= vim.api.nvim_buf_get_name(term.bufnr) then
						vim.api.nvim_buf_set_name(term.bufnr, term.display_name)
					end
				end,
				direction = "tab",
				shell = "fish",
			})
			local lazygit = require("toggleterm.terminal").Terminal:new({
				cmd = "lazygit",
				direction = "float",
				float_opts = {
					width = math.floor(vim.o.columns * 0.95),
					height = math.floor(vim.o.lines * 0.90),
				},
			})
			vim.keymap.set("n", "<Leader>g", function()
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
