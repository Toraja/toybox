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
				b = { rhs = "lua require('dap').toggle_breakpoint()", opts = { desc = "Toggle breakpoint" } },
				B = { rhs = "lua require('dap').clear_breakpoints()", opts = { desc = "Clear breakpoints" } },
				c = { rhs = "lua require('dap').continue()", opts = { desc = "Continue or start debugging" } },
				C = { rhs = "lua require('dap').run_to_cursor()", opts = { desc = "Progress debuging to cursor" } },
				l = { rhs = "lua require('dap').run_last()", opts = { desc = "Rerun the last debugging" } },
				i = { rhs = "lua require('dap').step_into()", opts = { desc = "Step in" } },
				n = { rhs = "lua require('dap').step_over()", opts = { desc = "Step over" } },
				o = { rhs = "lua require('dap').step_out()", opts = { desc = "Step out" } },
				r = { rhs = "lua require('dap').restart()", opts = { desc = "Restart debugging" } },
				t = { rhs = "lua require('dap').terminate()", opts = { desc = "Terminate" } },
				j = {
					rhs = "lua require('dap').down()",
					opts = { desc = "Go down in current stacktrace without stepping" },
				},
				k = {
					rhs = "lua require('dap').up()",
					opts = { desc = "Go up in current stacktrace without stepping" },
				},
			})
		end,
		keys = {
			{ debug_keymap_prefix, mode = { "n" }, desc = "Dap" },
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
					b = { rhs = "Telescope dap list_breakpoints", opts = { desc = "List breakpoints" } },
					c = { rhs = "Telescope dap commands", opts = { desc = "Commands" } },
					C = { rhs = "Telescope dap configurations", opts = { desc = "Configurations" } },
					f = { rhs = "Telescope dap frames", opts = { desc = "Frames" } },
					v = { rhs = "Telescope dap variables", opts = { desc = "Variables" } },
				}
			)
		end,
		keys = {
			{ debug_keymap_prefix .. "f", mode = { "n" }, desc = "Dap telescope" },
		},
	},
}
