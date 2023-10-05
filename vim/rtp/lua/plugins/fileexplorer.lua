return {
	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local function on_attach(bufnr)
				local lib = require("nvim-tree.lib")
				local api = require("nvim-tree.api")

				local function opts(desc)
					return {
						desc = "nvim-tree: " .. desc,
						buffer = bufnr,
						noremap = true,
						silent = true,
						nowait = true,
					}
				end

				local function open_in_background(node)
					node = node or lib.get_node_at_cursor()
					vim.cmd("tabnew " .. node.absolute_path .. " | tabprevious")
				end

				api.config.mappings.default_on_attach(bufnr)
				vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close Directory"))
				vim.keymap.set("n", "l", api.node.open.edit, opts("Open"))
				vim.keymap.set("n", "u", api.tree.change_root_to_parent, opts("Up"))
				vim.keymap.set("n", "t", open_in_background, opts("Open: New Tab Background"))
				vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
				vim.keymap.del("n", "<C-e>", { buffer = bufnr })
				vim.keymap.del("n", "H", { buffer = bufnr })
				vim.keymap.del("n", "s", { buffer = bufnr })
			end
			require("nvim-tree").setup({
				on_attach = on_attach,
				disable_netrw = true,
				respect_buf_cwd = true,
				update_cwd = true,
				git = {
					ignore = false,
				},
				view = {
					width = 40,
					float = {
						enable = true,
						quit_on_focus_loss = false,
						open_win_config = {
							relative = "editor",
							border = "rounded",
							width = 60,
							height = math.floor(vim.o.lines * 0.90),
							row = 1,
							col = 1,
							zindex = 1,
						},
					},
				},
				renderer = {
					highlight_opened_files = "all",
				},
				actions = {
					open_file = {
						quit_on_open = true,
					},
				},
			})
			require("keymap.which-key-helper").register_with_editable(
				"nvim-tree",
				vim.g.chief_key .. "e",
				vim.g.chief_key,
				{
					o = { "NvimTreeOpen", { desc = "Open" } },
					O = { "NvimTreeOpen %:h", { desc = "Open in the file's parent directory" } },
					e = { "NvimTreeToggle", { desc = "Toggle" } },
					E = { "NvimTreeFocus", { desc = "Focus" } },
					f = { "NvimTreeFindFile!", { desc = "Find file" } },
					r = { "NvimTreeRefresh", { desc = "Refresh" } },
				}
			)
			local nvimtree_augroud_id = vim.api.nvim_create_augroup("my_nvimtree", {})
			vim.api.nvim_create_autocmd({ "VimEnter" }, {
				group = nvimtree_augroud_id,
				callback = function(data)
					if vim.fn.isdirectory(data.file) == 1 then
						require("nvim-tree.api").tree.open({ path = data.file })
					end
				end,
			})
		end,
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				window = {
					position = "float",
					mappings = {
						["<Tab>"] = { "toggle_preview", config = { use_float = true } },
						["<C-]>"] = "focus_preview",
						["l"] = "open",
						["L"] = "expand_all_nodes",
						["h"] = "close_node",
						["H"] = "close_all_nodes",
						["<C-x>"] = "open_split",
						["<C-v>"] = "open_vsplit",
						["<C-t>"] = "open_tabnew",
						["a"] = {
							"add",
							config = {
								show_path = "absolute", -- "none", "relative", "absolute"
							},
						},
						["A"] = {
							"add_directory",
							config = {
								show_path = "absolute", -- "none", "relative", "absolute"
							},
						},
						["c"] = {
							"copy",
							config = {
								show_path = "absolute", -- "none", "relative", "absolute"
							},
						},
						["m"] = {
							"move",
							config = {
								show_path = "absolute", -- "none", "relative", "absolute"
							},
						},
					},
				},
				filesystem = {
					filtered_items = {
						visible = true,
					},
					window = {
						mappings = {
							["u"] = "navigate_up",
							["."] = "set_root",
							["F"] = "clear_filter",
						},
					},
				},
			})
			vim.cmd([[
				highlight NeoTreeTitleBar guifg=#000000
				]])
			require("keymap.which-key-helper").register_with_editable(
				"neo-tree",
				vim.g.chief_key .. "e",
				vim.g.chief_key,
				{
					b = { "Neotree toggle reveal source=buffers", { desc = "Buffers" } },
					e = { "Neotree toggle reveal_force_cwd", { desc = "Filesystem" } },
					E = {
						"Neotree toggle reveal_force_cwd dir=%:h",
						{ desc = "FS in the file's parent directory" },
					},
					g = { "Neotree toggle reveal_force_cwd source=git_status", { desc = "Git status" } },
				}
			)
		end,
	},
	{
		"kelly-lin/ranger.nvim",
		cond = function()
			return vim.fn.executable("ranger") ~= 0
		end,
		config = function()
			local ranger_nvim = require("ranger-nvim")
			ranger_nvim.setup({
				replace_netrw = true,
				keybinds = {
					["<CR>"] = ranger_nvim.OPEN_MODE.tabedit,
					["l"] = ranger_nvim.OPEN_MODE.tabedit,
					["<C-v>"] = ranger_nvim.OPEN_MODE.vsplit,
					["<C-h>"] = ranger_nvim.OPEN_MODE.split,
					["<C-t>"] = ranger_nvim.OPEN_MODE.tabedit,
					["<C-r>"] = ranger_nvim.OPEN_MODE.rifle,
				},
			})
		end,
		keys = {
			{ "<Leader>e", "<Cmd>lua require('ranger-nvim').open(true)<CR>", mode = { "n" }, desc = "ranger" },
		},
	},
}
