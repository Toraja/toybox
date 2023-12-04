return {
	{
		"michaelb/sniprun",
		dependencies = {
			{ "folke/which-key.nvim" },
		},
		build = "bash ./install.sh",
		config = function()
			require("sniprun").setup({
				display = { "NvimNotify" },
			})
			require("keymap.which-key-helper").register_with_editable(
				"sniprun",
				vim.g.chief_key .. "r",
				vim.g.chief_key,
				{
					a = { "%SnipRun", { desc = "SnipRun entire buffer" } },
					r = { "SnipRun", { desc = "SnipRun current line" } },
					s = { "SnipReset", { desc = "Stop execution of sniprun" } },
					c = { "SnipClose", { desc = "Clear text displayed by sniprun" } },
				}
			)
		end,
		keys = {
			{
				vim.g.chief_key .. "r",
				"<Cmd>WhichKey " .. vim.g.chief_key .. "r n<CR>",
				mode = { "n" },
				desc = "sniprun",
			},
			{ vim.g.chief_key .. "r", ":SnipRun<CR>", mode = { "v" }, desc = "sniprun" },
		},
	},
	{
		"desdic/greyjoy.nvim",
		dependencies = {
			{ "akinsho/toggleterm.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			local greyjoy = require("greyjoy")
			greyjoy.setup({
				output_results = "toggleterm",
				last_first = true,
				patterns = vim.list_extend(require("greyjoy.config").defaults.patterns, { "Makefile" }), -- patterns to find the root of the project
			})
			-- greyjoy.load_extension("generic")
			-- greyjoy.load_extension("vscode_tasks")
			greyjoy.load_extension("makefile")
			-- greyjoy.load_extension("kitchen")
			-- greyjoy.load_extension("cargo")
		end,
	},
}
