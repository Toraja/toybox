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
				test_runner = "richgo",
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
					"lua require('osv').launch({ port = 8086 })",
					{ desc = "Debug this file" },
				},
			})
		end,
		keys = {
			{
				"<LocalLeader>",
				function()
					require("which-key").show({ keys = "<LocalLeader>", mode = "n" })
				end,
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
	-- yaml
	{
		"someone-stole-my-name/yaml-companion.nvim",
		enabled = function()
			return vim.fn.executable("yaml-language-server") ~= 0
		end,
		-- ft = "yaml",
		ft = { "helm", "yaml" },
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
			require("lspconfig")["yamlls"].setup(require("yaml-companion").setup({
				schemas = {
					{
						name = "ExternalSecret",
						uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1beta1.json",
					},
				},
				lspconfig = {
					capabilities = require("cmp_nvim_lsp").default_capabilities(),
					settings = {
						yaml = {
							schemas = {
								["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = {
									".gitlab-ci.yml",
									".gitlab/ci/**",
								},
							},
							customTags = {
								"!reference sequence",
							},
						},
					},
				},
			}))
		end,
	},
	-- markup languages
	{
		"jakewvincent/mkdnflow.nvim",
		-- rocks = 'luautf8', -- Ensures optional luautf8 dependency is installed
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
		"AckslD/nvim-FeMaco.lua",
		config = function()
			require("femaco").setup()
		end,
		cmd = { "FeMaco" },
	},
	{
		"nvim-neorg/neorg",
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
