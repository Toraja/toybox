return {
	-- fish
	{
		"dag/vim-fish",
		ft = "fish",
	},
	-- go
	{
		"ray-x/go.nvim",
		ft = { "go", "gomod", "gosum" },
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
				"<Cmd>WhichKey " .. "<LocalLeader>" .. " n<CR>",
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
			return vim.fn.executable("composer") ~= 0
		end,
		branch = "master",
		build = "composer install --no-dev -o",
		ft = "php",
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
		end,
	},
	{
		"noahfrederick/vim-laravel",
		enabled = false,
	},
	-- rust
	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
		config = function()
			require("rust-tools").setup({})

			require("keymap.which-key-helper").register_for_ftplugin({
				B = { "RustToggleBackTrace", { desc = "Toggle RUST_BACKTRACE" } },
				c = { "lua require('rust-tools').open_cargo_toml.open_cargo_toml()", { desc = "Open Cargo.toml" } },
				-- g = { "RustDebuggables", { desc = "Debug" } }, -- TODO requires lldb-vscode. see: https://github.com/simrat39/rust-tools.nvim/wiki/Debugging
				h = { "lua require('rust-tools').inlay_hints.enable()", { desc = "Enable inlay hints" } },
				H = { "lua require('rust-tools').inlay_hints.disable()", { desc = "Disable inlay hints" } },
				j = { "lua require('rusu-tools').move_item.move_item(false)", { desc = "Move item down" } },
				k = { "lua require('rust-tools').move_item.move_item(true)", { desc = "Move item up" } },
				m = { "lua require('rust-tools').expand_macro.expand_macro()", { desc = "Expand macro" } },
				M = { "lua require('rust-tools').parent_module.parent_module()", { desc = "Go to parent module" } },
				r = { "lua require('rust-tools').runnables.runnables()", { desc = "Runnables" } },
			})
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
		dependencies = {
			{ "neovim/nvim-lspconfig" },
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope.nvim" },
		},
		config = function()
			require("telescope").load_extension("yaml_schema")
			require("lspconfig")["yamlls"].setup(require("yaml-companion").setup())
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
					conceal = true,
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
		"ellisonleao/glow.nvim",
		enabled = function()
			return vim.fn.executable("glow") ~= 0
		end,
		ft = "markdown",
		config = function()
			require("glow").setup({
				border = "rounded",
				width = math.floor(vim.o.columns * 0.90),
				height = math.floor(vim.o.lines * 0.90),
				width_ratio = 0.90, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
				height_ratio = 0.90,
			})
		end,
		cmd = { "Glow" },
	},
	{
		"iamcco/markdown-preview.nvim",
		enabled = false,
		build = function()
			vim.fn["mkdp#util#install"]()
		end,
		config = function()
			-- let $NVIM_MKDP_LOG_FILE = expand('~/tmp/mkdp.log') " default location is <plugin root>/app/mkdp.log
			-- let $NVIM_MKDP_LOG_LEVEL = 'debug'
			vim.g.mkdp_auto_close = 0
			vim.g.mkdp_echo_preview_url = 1
			vim.g.mkdp_page_title = "${name}"
			if vim.fn.executable("firefox") == 1 then
				vim.g.mkdp_browser = "firefox"
			end
			vim.g.mkdp_filetypes = { "markdown", "plantuml" }

			vim.api.nvim_buf_create_user_command(0, "MarkdownPreviewPublish", function()
				vim.g.mkdp_open_to_the_world = 1
			end, {})
			vim.api.nvim_buf_create_user_command(0, "MarkdownPreviewUnpublish", function()
				vim.g.mkdp_open_to_the_world = 0
			end, {})
			vim.api.nvim_buf_create_user_command(0, "MarkdownPreviewSetPort", function(command)
				vim.g.mkdp_port = command.fargs[1]
			end, { nargs = 1 })
			vim.api.nvim_buf_create_user_command(0, "MarkdownPreviewPublishWithPort", function(command)
				vim.g.mkdp_open_to_the_world = 1
				vim.g.mkdp_port = command.fargs[1]
			end, { nargs = 1 })
		end,
	},
	{
		"AckslD/nvim-FeMaco.lua",
		config = function()
			require("femaco").setup()
		end,
		cmd = { "FeMaco" },
	},
}
