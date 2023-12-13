local git_keymap_prefix = vim.g.chief_key .. "v"

return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local gitsigns_keymap_prefix = git_keymap_prefix .. "h"
					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, gitsigns_keymap_prefix .. l, r, opts)
					end

					-- Actions
					map({ "n", "x" }, "s", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Stage this hunk" })
					map("n", "S", gs.stage_buffer, { desc = "Stage all changes in the buffer" })
					map({ "n", "x" }, "r", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Restore this hunk to index" })
					map("n", "R", gs.reset_buffer, { desc = "Restore all unstaged changes in the buffer to index" })
					map("n", "u", gs.undo_stage_hunk, { desc = "Unstage the last staged hunk" })
					map("n", "p", gs.preview_hunk, { desc = "Preview this hunk" })
					map("n", "b", function()
						gs.blame_line({ full = true })
					end, { desc = "Blame current line" })

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
				end,
			})
		end,
	},
	{
		"sindrets/diffview.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("keymap.which-key-helper").register_with_editable("Git", git_keymap_prefix, vim.g.chief_key, {
				d = { "DiffviewOpen", { desc = "DiffviewOpen" } },
				y = { "DiffviewFileHistory %", { desc = "Diffview history of this file" } },
				Y = { "DiffviewFileHistory", { desc = "Diffview history of repository" } },
			})
		end,
		event = { "CmdlineEnter" },
		keys = {
			{
				git_keymap_prefix,
				"<Cmd>WhichKey " .. git_keymap_prefix .. " n<CR>",
				mode = { "n" },
				desc = "Git",
			},
		},
	},
}
