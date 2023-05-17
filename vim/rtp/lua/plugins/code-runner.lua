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
			require("keymap.which-key-helper").register_with_editable("sniprun", vim.g.chief_key .. "r", vim.g.chief_key, {
				a = { "%SnipRun", { desc = "SnipRun entire buffer" } },
				r = { "SnipRun", { desc = "SnipRun current line" } },
				s = { "SnipReset", { desc = "Stop execution of sniprun" } },
				c = { "SnipClose", { desc = "Clear text displayed by sniprun" } },
			})
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
}
