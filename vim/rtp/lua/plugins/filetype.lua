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
			{ "mfussenegger/nvim-dap" },
			{ "rcarriga/nvim-dap-ui" },
			{ "theHamsta/nvim-dap-virtual-text" },
		},
		config = function()
			require("go").setup({
				test_runner = "richgo",
				run_in_floaterm = true,
				textobjects = false,
				diagnostic = { -- set diagnostic to false to disable diagnostic
					hdlr = false, -- hook diagnostic handler
				},
			})
		end,
	},
	-- js
	{
		"moll/vim-node",
		ft = "javascript",
	},
	-- <php>
	{
		"phpactor/phpactor",
		enabled = function()
			return vim.fn.executable("composer") ~= 0
			-- return vim.fn.executable("composer") == 0
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
	},
	"noahfrederick/vim-laravel",
	-- rust
	{
		"simrat39/rust-tools.nvim",
		ft = "rust",
	},
	{
		"rust-lang/rust.vim",
		enabled = false,
		ft = "rust",
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
		config = function()
			require("mkdnflow").setup({
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
		end,
	},
	{
		"ellisonleao/glow.nvim",
		config = function()
			require("glow").setup({
				border = "rounded",
				width = math.floor(vim.o.columns * 0.90),
				height = math.floor(vim.o.lines * 0.90),
				width_ratio = 0.90, -- maximum width of the Glow window compared to the nvim window size (overrides `width`)
				height_ratio = 0.90,
			})
		end,
		cmd = "Glow",
	},
	{
		"iamcco/markdown-preview.nvim",
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

			vim.api.nvim_create_user_command("MarkdownPreviewPublish", function()
				vim.g.mkdp_open_to_the_world = 1
			end, {})
			vim.api.nvim_create_user_command("MarkdownPreviewUnpublish", function()
				vim.g.mkdp_open_to_the_world = 0
			end, {})
			vim.api.nvim_create_user_command("MarkdownPreviewSetPort", function(command)
				vim.g.mkdp_port = command.fargs[1]
			end, { nargs = 1 })
			vim.api.nvim_create_user_command("MarkdownPreviewPublishWithPort", function(command)
				vim.g.mkdp_open_to_the_world = 1
				vim.g.mkdp_port = command.fargs[1]
			end, { nargs = 1 })
		end,
	},
	{
		"weirongxu/plantuml-previewer.vim",
		dependencies = {
			"tyru/open-browser.vim",
		},
	},
	{
		"AckslD/nvim-FeMaco.lua",
		config = function()
			require("femaco").setup()
		end,
	},
}
