return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Actions
					map(
						{ "n", "x" },
						vim.g.chief_key .. "ghs",
						"<Cmd>Gitsigns stage_hunk<CR>",
						{ desc = "Stage this hunk" }
					)
					map("n", vim.g.chief_key .. "ghS", gs.stage_buffer, { desc = "Stage all changes in the buffer" })
					map(
						{ "n", "x" },
						vim.g.chief_key .. "ghr",
						"<Cmd>Gitsigns reset_hunk<CR>",
						{ desc = "Restore this hunk to index" }
					)
					map(
						"n",
						vim.g.chief_key .. "ghR",
						gs.reset_buffer,
						{ desc = "Restore all unstaged changes in the buffer to index" }
					)
					map("n", vim.g.chief_key .. "ghu", gs.undo_stage_hunk, { desc = "Unstage the last staged hunk" })
					map("n", vim.g.chief_key .. "ghp", gs.preview_hunk, { desc = "Preview this hunk" })
					map("n", vim.g.chief_key .. "gb", function()
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
			require("keymap.which-key-helper").register_with_editable("Git", vim.g.chief_key .. "g", vim.g.chief_key, {
				d = { "DiffviewOpen", { desc = "DiffviewOpen" } },
				v = { "DiffviewFileHistory %", { desc = "Diffview history of this file" } },
				V = { "DiffviewFileHistory", { desc = "Diffview history of repository" } },
			})
		end,
		event = { "CmdlineEnter" },
		keys = {
			{
				vim.g.chief_key .. "g",
				"<Cmd>WhichKey " .. vim.g.chief_key .. "g n<CR>",
				mode = { "n" },
				desc = "Git",
			},
		},
	},
}
