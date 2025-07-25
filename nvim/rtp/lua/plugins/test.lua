return {
	{
		"nvim-neotest/neotest",
		dependencies = {
			"folke/which-key.nvim",
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"nvim-neotest/neotest-go",
			"nvim-contrib/nvim-ginkgo",
			"nvim-neotest/neotest-plenary",
			-- "rouge8/neotest-rust",
			"mrcjkb/rustaceanvim",
		},
		config = function()
			local neotest_ns = vim.api.nvim_create_namespace("neotest")
			vim.diagnostic.config({
				virtual_text = {
					format = function(diagnostic)
						local message =
							diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
						return message
					end,
				},
			}, neotest_ns)
			-- add below to .nvim.lua to enable nvim-ginkgo for the project
			--[[
        local root_path = require("git").root_path()
        require("neotest").setup_project(root_path, {
          adapters = {
            require("nvim-ginkgo"),
          },
        })
      ]]
			require("neotest").setup({
				adapters = {
					require("neotest-go"),
					-- require("nvim-ginkgo"),
					require("neotest-plenary"), -- the name of test file must be *_spec.lua
					-- require("neotest-rust"),
					require("rustaceanvim.neotest"),
					-- For reference
					-- require("neotest-vim-test")({
					--   ignore_file_types = { "python", "vim", "lua" },
					-- }),
				},
				floating = {
					max_width = vim.opt.columns:get(),
					option = {
						wrap = true,
					},
				},
				-- Tab for output panel opens in background so you need to focus it.
				-- Only `tab split` opens the tab right, but adding command to move back to the last tab opens the tab left to the current tab.
				-- (`tabnext` also behaves same)
				-- output_panel = {
				--   open = "tab split | LastTab",
				-- },
			})
			require("keymap.which-key-helper").register_with_editable(
				"neotest",
				vim.g.chief_key .. "t",
				vim.g.chief_key,
				{
					g = {
						rhs = "lua require('neotest').run.run({strategy = 'dap'})",
						opts = { desc = "Debug nearest" },
					},
					t = { rhs = "lua require('neotest').run.run()", opts = { desc = "Test nearest" } },
					T = { rhs = "lua require('neotest').run.run(vim.fn.expand('%'))", opts = { desc = "Test file" } },
					s = { rhs = "lua require('neotest').run.stop()", opts = { desc = "Stop test" } },
					o = {
						rhs = "lua require('neotest').output.open({ quiet = false })",
						opts = { desc = "Open test output" },
					},
					O = {
						rhs = "lua require('neotest').output.open({ enter = true, quiet = false })",
						opts = { desc = "Open test output and focus the window" },
					},
					p = {
						rhs = "lua require('neotest').output_panel.toggle()",
						opts = { desc = "Toggle output panel" },
					},
					m = { rhs = "lua require('neotest').summary.toggle()", opts = { desc = "Toggle summary" } },
				}
			)
			vim.keymap.set(
				"n",
				"[n",
				"<cmd>lua require('neotest').jump.prev({})<CR>",
				{ desc = "Jump to previous test" }
			)
			vim.keymap.set("n", "]n", "<cmd>lua require('neotest').jump.next({})<CR>", { desc = "Jump to next test" })
		end,
		keys = {
			{ vim.g.chief_key .. "t", mode = { "n" }, desc = "neotest" },
		},
	},
}
