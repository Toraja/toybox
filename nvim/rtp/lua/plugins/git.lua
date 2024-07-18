local git_keymap_prefix = vim.g.chief_key .. "v"

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
					local function git_map(mode, l, r, opts)
						map(mode, git_keymap_prefix .. l, r, opts)
					end

					-- Actions
					git_map("n", "s", "<Cmd>Gitsigns stage_hunk<CR>", { desc = "Stage this hunk" })
					git_map("x", "s", ":Gitsigns stage_hunk<CR>", { desc = "Stage selection" })
					git_map("n", "S", gs.stage_buffer, { desc = "Stage all changes in the buffer" })
					git_map("n", "r", "<Cmd>Gitsigns reset_hunk<CR>", { desc = "Restore this hunk to index" })
					git_map("x", "r", ":Gitsigns reset_hunk<CR>", { desc = "Restore selection to index" })
					git_map("n", "R", gs.reset_buffer, { desc = "Restore all unstaged changes in the buffer to index" })
					git_map("n", "u", gs.undo_stage_hunk, { desc = "Unstage the last staged hunk" })
					git_map("n", "p", gs.preview_hunk, { desc = "Preview this hunk" })
					git_map("n", "b", function()
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
			local actions = require("diffview.actions")
			local diffview_foldlevel
			require("diffview").setup({
				hooks = {
					view_leave = function(_)
						diffview_foldlevel = vim.opt_local.foldlevel:get()
					end,
					diff_buf_win_enter = function(_)
						if diffview_foldlevel ~= nil then
							vim.opt_local.foldlevel = diffview_foldlevel
						end
					end,
				},
				keymaps = {
          -- stylua: ignore
					view = {
						{ "n", "<C-t><C-f>", actions.goto_file_tab, { desc = "Open the file in a new tabpage" } },
					},
				},
			})
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
				function()
					require("which-key").show({ keys = git_keymap_prefix, mode = "n" })
				end,
				mode = { "n" },
				desc = "Git",
			},
		},
	},
}
