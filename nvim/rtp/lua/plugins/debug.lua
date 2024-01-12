local debug_keymap_prefix = vim.g.chief_key .. "g"

return {
	{
		"mfussenegger/nvim-dap",
		lazy = true,
		config = function()
			-- just for loading simultaneously
			require("dapui")
			require("nvim-dap-virtual-text")

			vim.fn.sign_define("DapBreakpoint", { text = "B", texthl = "Started", numhl = "Started" })
			vim.fn.sign_define("DapLogPoint", { text = "L", texthl = "Started", numhl = "Started" })
			vim.fn.sign_define("DapStopped", { text = ">", texthl = "Blocked", numhl = "Blocked" })

			require("keymap.which-key-helper").register_with_editable("Dap", debug_keymap_prefix, vim.g.chief_key, {
				b = { "lua require('dap').toggle_breakpoint()", { desc = "Toggle breakpoint" } },
				B = { "lua require('dap').clear_breakpoints()", { desc = "Clear breakpoints" } },
				c = { "lua require('dap').continue()", { desc = "Continue or start debugging" } },
				C = { "lua require('dap').run_to_cursor()", { desc = "Progress debuging to cursor" } },
				l = { "lua require('dap').run_last()", { desc = "Rerun the last debugging" } },
				i = { "lua require('dap').step_into()", { desc = "Step in" } },
				n = { "lua require('dap').step_over()", { desc = "Step over" } },
				o = { "lua require('dap').step_out()", { desc = "Step out" } },
				r = { "lua require('dap').restart()", { desc = "Restart debugging" } },
				t = { "lua require('dap').terminate()", { desc = "Terminate" } },
				j = { "lua require('dap').down()", { desc = "Go down in current stacktrace without stepping" } },
				k = { "lua require('dap').up()", { desc = "Go up in current stacktrace without stepping" } },
			})
		end,
		keys = {
			{
				debug_keymap_prefix,
				"<Cmd>WhichKey " .. debug_keymap_prefix .. " n<CR>",
				mode = { "n" },
				desc = "Dap",
			},
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("dapui").setup()

			local dap, dapui = require("dap"), require("dapui")
			-- auto start dapui when debug starts
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			-- auto close dapui when debug starts
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.keymap.set(
				"n",
				debug_keymap_prefix .. "q",
				"<Cmd>lua require('dapui').close()<CR>",
				{ desc = "Close dap UI" }
			)
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
	{
		"nvim-telescope/telescope-dap.nvim",
		lazy = true,
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("telescope").load_extension("dap")

			local ts_dap_keymap_prefix = debug_keymap_prefix .. "f"
			require("keymap.which-key-helper").register_with_editable(
				"Dap telescope",
				ts_dap_keymap_prefix,
				vim.g.chief_key,
				{
					b = { "Telescope dap list_breakpoints", { desc = "List breakpoints" } },
					c = { "Telescope dap commands", { desc = "Commands" } },
					C = { "Telescope dap configurations", { desc = "Configurations" } },
					f = { "Telescope dap frames", { desc = "Frames" } },
					v = { "Telescope dap variables", { desc = "Variables" } },
				}
			)
		end,
		keys = {
			{
				debug_keymap_prefix .. "f",
				"<Cmd>WhichKey " .. debug_keymap_prefix .. "f n<CR>",
				mode = { "n" },
				desc = "Dap telescope",
			},
		},
	},
}
