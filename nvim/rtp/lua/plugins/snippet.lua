return {
	{
		"L3MON4D3/LuaSnip",
		version = "v1.*",
		dependencies = {
			{ "rafamadriz/friendly-snippets" },
			{ "saadparwaiz1/cmp_luasnip" },
		},
		config = function()
			require("luasnip").config.setup({ store_selection_keys = "<C-]>" })
			-- Both sources can be enabled at the same time
			local ls_vscode = require("luasnip.loaders.from_vscode")
			ls_vscode.lazy_load() -- enable LSP style snippets
			-- require("luasnip.loaders.from_snipmate").lazy_load()

			vim.keymap.set({ "i", "s" }, "<C-]>", "<Plug>luasnip-expand-or-jump")
			vim.keymap.set({ "i", "s" }, "<C-s>", "<Plug>luasnip-jump-next")
			vim.keymap.set({ "i", "s" }, "<M-s>", "<Plug>luasnip-jump-prev")
			vim.keymap.set("s", "<Tab>", "<Esc>i", { noremap = true })
			vim.keymap.set("s", "<C-a>", "<Esc>a", { noremap = true })

			vim.api.nvim_create_user_command("LuaSnipLoadSnippetsVSCode", ls_vscode.load, {})
		end,
	},
}
