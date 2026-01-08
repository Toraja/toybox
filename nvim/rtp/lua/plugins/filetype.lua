return {
	-- fish
	{
		"dag/vim-fish",
		ft = "fish",
	},
	-- go
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod", "gosum", "gotexttmpl", "gohtmltmpl" },
		dependencies = {
			{ "ray-x/guihua.lua", build = "cd lua/fzy && make" },
			-- dap dependencies not included to enable lazy loading
		},
		config = function()
			require("go").setup({
				diagnostic = { -- set diagnostic to false to disable diagnostic
					hdlr = false, -- hook diagnostic handler
				},
				lsp_keymaps = false,
				icons = false,
				dap_debug_keymap = false,
				textobjects = false,
				run_in_floaterm = true,
			})
		end,
	},
	-- js
	{
		"moll/vim-node",
		ft = "javascript",
	},
	-- lua
	{
		"jbyuki/one-small-step-for-vimkind",
		enabled = false, -- this is quite buggy and endless errors make it impossible to leave vim
		lazy = true,
		dependencies = {
			{ "mfussenegger/nvim-dap" },
		},
		config = function()
			local dap = require("dap")
			dap.configurations.lua = {
				{
					type = "nlua",
					request = "attach",
					name = "Attach to running Neovim instance",
				},
			}

			dap.adapters.nlua = function(callback, config)
				callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
			end

			require("keymap.which-key-helper").register_for_ftplugin({
				g = {
					rhs = "lua require('osv').launch({ port = 8086 })",
					opts = { desc = "Debug this file" },
				},
			})
		end,
		keys = {
			{
				"<LocalLeader>",
				mode = { "n" },
				desc = "Dap",
				-- Top level `ft` option loads the plugin immediately when lua file is opened
				-- even if `keys` option is set. Specify filetype here so that keymap is effective
				-- only for lua.
				ft = "lua",
			},
		},
	},
	-- <php>
	{
		"phpactor/phpactor",
		enabled = function()
			return vim.fn.executable("phpactor") ~= 0
		end,
		branch = "master",
		ft = "php",
		init = function()
			vim.g.PhpactorRootDirectoryStrategy = function()
				if require("git").is_inside_work_tree() then
					return require("git").root_path()
				else
					return "."
				end
			end
		end,
	},
	{
		"vim-php/tagbar-phpctags.vim",
		ft = "php",
	},
	{
		"stephpy/vim-php-cs-fixer",
		ft = "php",
		init = function()
			vim.g.php_cs_fixer_enable_default_mapping = 0
			if require("git").is_inside_work_tree() then
				vim.g.php_cs_fixer_cache = require("git").root_path() .. "/.php_cs.cache"
				vim.g.php_cs_fixer_config_file = require("git").root_path() .. "/.php_cs.dist"
			else
				vim.g.php_cs_fixer_cache = "."
				vim.g.php_cs_fixer_config_file = "."
			end
		end,
	},
	{
		"noahfrederick/vim-laravel",
		enabled = false,
	},
	-- rust
	{
		"mrcjkb/rustaceanvim",
		-- must be loaded always as this is required by neotest
		-- enabled = vim.fn.executable("cargo") == 1,
		-- ft = "rust",
		version = "*",
		init = function()
			local toggleterm_executor = {
				execute_command = function(command, args, cwd, _)
					local ok, term = pcall(require, "toggleterm.terminal")
					if not ok then
						vim.schedule(function()
							vim.notify("toggleterm not found.", vim.log.levels.ERROR)
						end)
						return
					end

					local shell = require("rustaceanvim.shell")
					term.Terminal
						:new({
							dir = cwd,
							cmd = shell.make_command_from_args(command, args),
							close_on_exit = false,
						})
						:toggle()
				end,
			}

			-- Update this path
			local extension_path = vim.env.HOME .. "/.local/share/code-server/extensions/vadimcn.vscode-lldb/"
			local codelldb_path = extension_path .. "adapter/codelldb"
			local liblldb_path = extension_path .. "lldb/lib/liblldb"
			---@diagnostic disable-next-line: undefined-field
			local this_os = vim.uv.os_uname().sysname

			-- The path is different on Windows
			if this_os:find("Windows") then
				codelldb_path = codelldb_path .. ".exe"
				liblldb_path = liblldb_path .. ".dll"
			elseif this_os:find("Linux") then
				liblldb_path = liblldb_path .. ".so"
			else -- MacOS
				liblldb_path = liblldb_path .. ".dylib"
			end
			local cfg = require("rustaceanvim.config")

			vim.g.rustaceanvim = {
				tools = {
					executor = toggleterm_executor,
					test_executor = toggleterm_executor,
					crate_test_executor = toggleterm_executor,
				},
				dap = {
					adapter = cfg.get_codelldb_adapter(codelldb_path, liblldb_path),
				},
			}
		end,
	},
	{
		"saecki/crates.nvim",
		ft = "toml",
		version = "*",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
		},
		config = function()
			require("crates").setup()
			vim.api.nvim_create_autocmd("BufRead", {
				group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
				pattern = "Cargo.toml",
				callback = function()
					require("cmp").setup.buffer({ sources = { { name = "crates" } } })
				end,
			})
		end,
	},
	-- markup languages
	{
		"jakewvincent/mkdnflow.nvim",
		enabled = false,
		ft = "markdown",
		config = function()
			local mkdnflow = require("mkdnflow")

			mkdnflow.setup({
				modules = {
					bib = true,
					buffers = true,
					conceal = true,
					cursor = true,
					folds = true,
					links = true,
					lists = true,
					maps = false,
					paths = true,
					tables = true,
				},
				links = {
					-- conceal = true, -- when true, it sets conceallevel=2 automatically
				},
				to_do = {
					symbols = { " ", "-", "x" },
					update_parents = true,
					not_started = " ",
					in_progress = "-",
					complete = "x",
				},
			})

			vim.keymap.set("n", "]]", function()
				mkdnflow.cursor.toHeading(nil)
			end, { desc = "Jump to next heading", buffer = true })
			vim.keymap.set("n", "[[", function()
				mkdnflow.cursor.toHeading(nil, {})
			end, { desc = "Jump to previous heading", buffer = true })
			vim.keymap.set("n", "o", function()
				mkdnflow.lists.newListItem(false, false, true, "i", "o")
			end, { desc = "Add list item below", buffer = true })
			vim.keymap.set("n", "O", function()
				mkdnflow.lists.newListItem(false, true, true, "i", "O")
			end, { desc = "Add list item above", buffer = true })
			vim.keymap.set("n", "<C-]>", function()
				mkdnflow.links.followLink()
			end, { desc = "Follow link", buffer = true })
			vim.keymap.set("n", "<C-t><C-]>", function()
				vim.cmd("tab split")
				mkdnflow.links.followLink()
			end, { desc = "Follow link in tab", buffer = true })
			vim.keymap.set("n", "<C-w><C-]>", function()
				vim.cmd("split")
				mkdnflow.links.followLink()
			end, { desc = "Follow link in horizontal window", buffer = true })
		end,
	},
	{
		"MeanderingProgrammer/render-markdown.nvim",
		enabled = false,
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
		ft = { "markdown", "codecompanion", "Avante" },
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {
			anti_conceal = {
				-- Setting this to false is supposed to keep concealing the text on the cursorline, but that is not working.
				enabled = false,
			},
			completions = { lsp = { enabled = true } },
			code = {
				border = "thick",
			},
		},
	},
	{
		"OXY2DEV/markview.nvim",
		lazy = false,
		ft = { "markdown", "codecompanion", "Avante" },
		config = function()
			local symbols = require("markview.symbols")
			local states = require("markview.extras.checkboxes").config.states
			table.insert(states[1], "~")
			table.insert(states[1], "=")
			require("markview").setup({
				preview = {
					filetypes = { "markdown", "codecompanion", "Avante" },
					ignore_buftypes = {},
				},
				experimental = {
					check_rtp_message = false,
				},
				markdown_inline = {
					enable = false,
					checkboxes = {
						checked = {
							text = symbols.entries.checkmark,
							hl = "MarkviewCheckboxChecked",
							scope_hl = "MarkviewInlineCode",
						},
						unchecked = {
							text = symbols.typst_entries.ballot,
							hl = "MarkviewCheckboxUnchecked",
							scope_hl = "MarkviewInlineCode",
						},
						["/"] = {
							text = "󰥔",
							hl = "MarkviewCheckboxProgress",
							scope_hl = "MarkviewInlineCode",
						},
						["~"] = {
							text = "",
							hl = "MarkviewCheckboxCancelled",
							scope_hl = "MarkviewCheckboxStriked",
						},
						["="] = {
							text = "",
							hl = "MarkviewCheckboxPending",
							scope_hl = "MarkviewInlineCode",
						},
					},
				},
			})
		end,
	},
	{
		"bngarren/checkmate.nvim",
		ft = { "markdown" },
		dependencies = {
			"cpea2506/one_monokai.nvim",
		},
		-- Somehow, calling require("one_monokai.colors") in `opts` breaks the entire highlight setting, so use `config` instead.
		config = function()
			local one_monokai_colors = require("one_monokai.colors")
			require("checkmate").setup({
				files = { "*.md" },
				keys = {}, -- disable default keymaps
				todo_states = {
					-- Built-in states (cannot change markdown or type)
					unchecked = { marker = "☐" },
					checked = { marker = "✓" },
					-- Custom states
					in_progress = {
						marker = "◐",
						markdown = ".",
						type = "incomplete",
						order = 50,
					},
					cancelled = {
						marker = "✗",
						markdown = "~",
						type = "inactive",
						order = 2,
					},
					on_hold = {
						marker = "",
						markdown = "=",
						type = "incomplete",
						order = 100,
					},
				},
				style = {
					CheckmateInProgressMarker = { fg = one_monokai_colors.cyan },
					CheckmateCancelledMarker = { fg = one_monokai_colors.red },
					CheckmateCancelledMainContent = { fg = one_monokai_colors.dark_gray, strikethrough = true },
					CheckmateOnHoldMarker = { fg = one_monokai_colors.purple },
				},
				use_metadata_keymaps = false,
			})
			-- Disable CheckmateUncheckedMainContent highlight as it covers up other highlights
			vim.api.nvim_set_hl(0, "CheckmateUncheckedMainContent", {})
		end,
	},
	{
		"nvim-neorg/neorg",
		-- Disabled as lua 5.1 is required (tree-sitter-norg requires luarocks.nvim which requires lua to be 5.1)
		-- https://github.com/nvim-neorg/neorg/issues/1715
		enabled = false,
		ft = "norg",
		version = "*",
		dependencies = { "luarocks.nvim" },
		config = function()
			require("neorg").setup({
				load = {
					["core.defaults"] = {
						config = {
							disable = {
								-- module list goes here
								"core.clipboard.code-blocks", -- this module appends new line to any yank inside code block
							},
						},
					}, -- Loads default behaviour
					["core.esupports.indent"] = {
						config = {
							indents = {
								_ = {
									modifiers = {}, -- disable automatic indentation under headings
									indent = 0,
								},
							},
							-- If true, when <CR> at the end of line, the next line is left padded so thah the cursor aligns with the end of the previous line.
							-- This is unwanted.
							-- dedent_excess = false,
						},
					},
					["core.concealer"] = {
						config = {
							icons = {
								todo = {
									undone = {
										icon = " ",
									},
								},
							},
						},
					}, -- Adds pretty icons to your documents
					["core.dirman"] = { -- Manages Neorg workspaces
						config = {
							workspaces = {
								notes = "~/workspace/notes",
							},
						},
					},
					["core.highlights"] = {
						config = {
							dim = {
								markup = {
									verbatim = {
										reference = "Special",
										percentage = 0,
									},
								},
							},
						},
					},
					["core.qol.todo_items"] = {
						config = {
							create_todo_items = false,
						},
					},
				},
			})
		end,
	},
}
