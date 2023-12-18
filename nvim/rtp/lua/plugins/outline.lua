vim.keymap.set("n", "<Leader>o", function()
	if vim.lsp.buf.server_ready() then
		vim.cmd("SymbolsOutlineToggle")
	else
		vim.cmd("AerialToggle!")
	end
end, { desc = "Toggle outline" })
vim.keymap.set("n", "<Leader>O", function()
	if vim.lsp.buf.server_ready() then
		vim.cmd("SymbolsOutlineFocus")
	else
		vim.cmd("AerialOpen")
	end
end, { desc = "Focus outline" })

return {
	{
		"nvim-treesitter/nvim-treesitter-context",
		dependencies = { "nvim-treesitter" },
		config = function()
			require("treesitter-context").setup({
				max_lines = 12,
				multiline_threshold = 5,
			})
		end,
	},
	{
		"simrat39/symbols-outline.nvim",
		config = function()
			local symbols_outline = require("symbols-outline")
			symbols_outline.setup({
				autofold_depth = 0,
				auto_unfold_hover = false,
			})

			local function is_window_open_in_current_tab(win_id)
				return vim.api.nvim_win_get_tabpage(win_id) == vim.api.nvim_get_current_tabpage()
			end

			local function is_outline_open_in_current_tab()
				if not symbols_outline.view:is_open() then
					return false
				end
				return is_window_open_in_current_tab(symbols_outline.view.winnr)
			end

			local function symbols_outline_focus()
				if is_outline_open_in_current_tab() then
					vim.api.nvim_set_current_win(symbols_outline.view.winnr) -- winnr is actually win id
					return
				end

				if symbols_outline.view:is_open() then
					symbols_outline.close_outline()
				end

				symbols_outline.open_outline()
			end

			local function symbols_outline_toggle()
				if is_outline_open_in_current_tab() then
					symbols_outline.close_outline()
					return
				end

				if symbols_outline.view:is_open() then
					symbols_outline.close_outline()
				end

				symbols_outline.open_outline()
			end

			vim.api.nvim_create_user_command("SymbolsOutlineToggle", symbols_outline_toggle, {})
			vim.api.nvim_create_user_command("SymbolsOutlineFocus", symbols_outline_focus, {})
		end,
		cmd = { "SymbolsOutlineToggle", "SymbolsOutlineFocus" },
	},
	{
		"stevearc/aerial.nvim",
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("aerial").setup({
				min_width = 20,
				show_guides = true,
			})
		end,
		cmd = { "AerialToggle", "AerialOpen" },
	},
}
