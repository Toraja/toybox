return {
	{
		"nvim-tree/nvim-tree.lua",
		enabled = false,
		dependencies = {
			{ "nvim-tree/nvim-web-devicons" },
			{ "JMarkin/nvim-tree.lua-float-preview" },
		},
		config = function()
			local function on_attach(bufnr)
				require("float-preview").attach_nvimtree(bufnr)
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
				vim.keymap.del("n", "<Tab>", { buffer = bufnr })
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
				diagnostics = {
					enable = true,
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
		"JMarkin/nvim-tree.lua-float-preview",
		lazy = true,
		opts = {
			mapping = {
				-- scroll down float buffer
				down = { "<M-j>" },
				-- scroll up float buffer
				up = { "<M-k>" },
				-- enable/disable float windows
				toggle = { "<Tab>", "<C-_>" }, -- <Tab> does not get mapped
			},
			window = {
				wrap = false,
				trim_height = false,
				open_win_config = function()
					return {
						style = "minimal",
						relative = "editor",
						border = "rounded",
						width = vim.opt.columns:get() - 67,
						height = math.floor(vim.o.lines * 0.90),
						row = 1,
						col = 63,
						zindex = 1,
					}
				end,
			},
		},
	},
	{
		"nvim-neo-tree/neo-tree.nvim",
		-- enabled = false,
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
			"MunifTanjim/nui.nvim",
		},
		config = function()
			---@param num integer
			---@return string
			local function toBase8(num)
				local base = 8
				local result = ""
				while num > 0 do
					local remainder = num % base
					result = remainder .. result
					num = math.floor(num / base)
				end
				return result
			end
			require("neo-tree").setup({
				window = {
					position = "float",
					popup = { -- settings that apply to float position only
						size = { height = math.floor(vim.o.lines * 0.85), width = math.floor(vim.o.columns * 0.50) },
						position = "50%", -- 50% means center it
					},
					mappings = {
						["<C-_>"] = { "toggle_preview", config = { use_float = true } },
						["<C-]>"] = "focus_preview",
						["l"] = "open",
						["L"] = "expand_all_nodes",
						["h"] = "close_node",
						["H"] = "close_all_nodes",
						["<C-x>"] = "open_split",
						["<C-v>"] = "open_vsplit",
						["<C-t>"] = "open_tabnew",
						-- the behaviour is clumsy as the neo-tree window blinks
						-- ["X"] = {
						-- 	function(state)
						-- 		local cmds = require("neo-tree.sources.common.commands")
						-- 		local original_tab_number = vim.print(vim.api.nvim_tabpage_get_number(0))
						-- 		cmds.open_tabnew(state, cmds.toggle_directory)
						-- 		vim.cmd(original_tab_number .. "tabnext")
						-- 		require("neo-tree.command").execute({})
						-- 	end,
						-- },
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
						["c"] = "none",
						["cc"] = {
							desc = "yank filepath",
							function(state)
								local node = state.tree:get_node()
								require("register").yank_or_clip(node.path)
								vim.notify("Yanked filepath")
							end,
						},
						["cf"] = {
							desc = "yank filename",
							function(state)
								local node = state.tree:get_node()
								require("register").yank_or_clip(node.name)
								vim.notify("Yanked filename")
							end,
						},
						["m"] = {
							desc = "change file mode",
							function(state)
								local node = state.tree:get_node()
								local input_mode = require("text.input").get_input("mode: ")
								if input_mode == nil then
									return
								end
								local result = vim.system({ "chmod", input_mode, node.path }):wait()
								if result.code ~= 0 then
									vim.notify(result.stderr, nil, { title = "chmod" })
									return
								end
								require("neo-tree.sources.filesystem.commands").refresh(state)
								-- TODO: tried to get the new file mode but the below code returns the old value
								-- local new_node = state.tree:get_node()
								-- ---@diagnostic disable-next-line: param-type-mismatch
								-- local result_mode = toBase8(tonumber(new_node.stat.mode))
								-- vim.notify(result_mode)
							end,
						},
						["M"] = {
							desc = "print file mode",
							function(state)
								local node = state.tree:get_node()
								---@diagnostic disable-next-line: param-type-mismatch
								local mode = toBase8(tonumber(node.stat.mode))
								vim.notify(mode, nil, { title = "file mode" })
							end,
						},
						["gx"] = {
							"move",
							config = {
								show_path = "absolute", -- "none", "relative", "absolute"
							},
						},
						["y"] = {
							"copy_to_clipboard",
							nowait = true,
						},
						["gy"] = {
							"copy",
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
					hijack_netrw_behavior = "open_current",
					window = {
						mappings = {
							["u"] = "navigate_up",
							["."] = "set_root",
							["F"] = "clear_filter",
						},
					},
				},
			})

			vim.api.nvim_set_hl(0, "NeoTreeTitleBar", { link = "TermCursor" })
			vim.api.nvim_set_hl(0, "NeoTreePreview", { link = "TermCursor" })

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
		event = "VeryLazy",
		-- `keys` for lazy loading cannot be used as directories should be opened in neo-tree
	},
}
