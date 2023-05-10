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
				on_open = function()
					vim.cmd([[
								startinsert
								]])
				end,
				direction = "tab",
				shell = "fish",
			})
			vim.keymap.set("n", "<Leader>g", function()
				require("toggleterm.terminal").Terminal
					:new({
						cmd = "lazygit",
						direction = "float",
						float_opts = {
							width = math.floor(vim.o.columns * 0.95),
							height = math.floor(vim.o.lines * 0.90),
						},
					})
					:toggle()
			end, { desc = "lazygit" })
		end,
	},
	{
		"willothy/flatten.nvim",
		opts = {
			window = {
				open = "tab",
			},
		},
	},
}
