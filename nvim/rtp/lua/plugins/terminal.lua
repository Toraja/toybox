return {
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			local shell = "fish"
			require("toggleterm").setup({
				open_mapping = [[<C-\>]],
				on_create = function(term)
					vim.opt_local.signcolumn = "no"
					-- XXX: when reopening the toggleterm buffer, if directory the name of which is same as
					-- the toggleterm buffer name exists in cwd, neo-tree tries to open the directory and
					-- the buffer is closed immediately.
					-- So wrap the buffer name with [] so that it will not be match directory names.
					-- The downside is that tabline setting cannot get devicon by the name.
					if term.display_name and term.display_name ~= vim.api.nvim_buf_get_name(term.bufnr) then
						vim.api.nvim_buf_set_name(term.bufnr, "[" .. term.display_name .. "]")
					else
						vim.api.nvim_buf_set_name(term.bufnr, "[" .. shell .. "]")
					end
				end,
				on_open = function()
					vim.cmd([[
								startinsert
								]])
				end,
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
