local M = {}

function M.setup(opts)
	opts = opts or {}
	require("lazy").setup({
		{
			"cpea2506/one_monokai.nvim",
			lazy = false,
			priority = 1000,
			config = function()
				require("one_monokai").setup({
					colors = {
						bg = "NONE",
						cyan = "#00d7ff",
						claret = "#7f1734",
						castleton_green = "#00563f",
						dark_powder_blue = "#003399",
						cursor_line_bg = "#141414",
					},
					themes = function(colors)
						return {
							CursorLine = { bg = colors.cursor_line_bg },
							CursorLineNr = { fg = colors.fg, bg = colors.cursor_line_bg },
							DiffAdd = { bg = colors.castleton_green },
							DiffDelete = { fg = colors.white, bg = colors.claret },
							DiffChange = { bg = colors.dark_gray },
							DiffText = { bg = colors.dark_powder_blue },
							Search = { fg = colors.yellow, bg = colors.bg, reverse = true },
							TabLine = { fg = colors.none, bg = colors.none, reverse = true },
							Todo = { fg = colors.pink, bold = true, italic = true, reverse = true },
							Blocked = { fg = colors.aqua, reverse = true },
							AnnoyingSpaces = { bg = colors.dark_gray },
							TreesitterContextBottom = { underline = true },
						}
					end,
				})
			end,
		},
		{
			"tanvirtin/monokai.nvim",
			enabled = false,
			lazy = false,
			priority = 1000,
			config = function()
				require("monokai").setup({
					palette = require("monokai").pro,
					-- palette = require('monokai').soda,
					-- palette = require('monokai').ristretto,
					custom_hlgroups = {
						Normal = { bg = "#000000" },
						CursorLine = { bg = "#151515" },
						TabLine = { reverse = true },
						AnnoyingSpaces = { bg = "#333842" },
					},
				})
			end,
		},
		{
			"folke/which-key.nvim",
			config = function()
				vim.cmd([[
				highlight link FloatBorder Normal
				highlight link WhichKeyFloat Normal
				highlight link WhichKey Type
				highlight link WhichKeyDesc Type
				]])
				require("which-key").setup({
					plugins = {
						presets = {
							operators = false, -- adds help for operators like d, y, ...
						},
					},
					operators = {
						d = "Delete",
						c = "Change",
						y = "Yank (copy)",
						["g~"] = "Toggle case",
						["gu"] = "Lowercase",
						["gU"] = "Uppercase",
						[">"] = "Indent right",
						["<lt>"] = "Indent left",
						["zf"] = "Create fold",
						["!"] = "Filter though external program",
						-- ["v"] = "Visual Character Mode",
						gc = "Comments",
					},
					popup_mappings = {
						scroll_down = "<PageDown>", -- binding to scroll down inside the popup
						scroll_up = "<PageUp>", -- binding to scroll up inside the popup
					},
					window = {
						border = "rounded", -- none, single, double, shadow
						position = "bottom", -- bottom, top
						margin = { 0, 0, 0, 0 }, -- extra window margin [top, right, bottom, left]
						padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
						winblend = 0, -- value between 0-100 0 for fully opaque and 100 for fully transparent
					},
					layout = {
						height = { min = 4, max = 25 }, -- min and max height of the columns
						width = { min = 20, max = 50 }, -- min and max width of the columns
						spacing = 5, -- spacing between columns
						align = "left", -- align columns left, center or right
					},
				})
			end,
		},

		-- git
		{
			"tpope/vim-fugitive",
			enabled = false,
			config = function()
				vim.cmd([[
				cnoreabbrev gs Git
				cnoreabbrev gg Git log
				cnoreabbrev ggg vertical sbuffer <Bar> Gllog
				cnoreabbrev gd Gvdiffsplit
				cnoreabbrev gps Git push
				]])
				-- vim.g.fugitive_no_maps = 1 -- prevent <C-n/p> to be mapped
				vim.keymap.set("n", "<Leader>gs", "<Cmd>tab Git<CR>", { desc = "vim-fugitive" })
				vim.keymap.set("n", "<Leader>gG", "<Cmd>tab Git log<CR>", { desc = "git log [tab]" })
				vim.keymap.set("n", "<Leader>gg", "<Cmd>vertical Git log<CR>", { desc = "git log [vert]" })
				vim.keymap.set("n", "<Leader>gB", "<Cmd>Git blame<CR>", { desc = "git blame entire file" })
			end,
		},
		{
			"junegunn/gv.vim",
			enabled = false,
			config = function()
				vim.keymap.set("n", "<Leader>gV", "<Cmd>GV<CR><Cmd>+tabmove<CR>", { desc = "GV [repo]" })
				vim.keymap.set("n", "<Leader>gv", "<Cmd>GV!<CR><Cmd>+tabmove<CR>", { desc = "GV [file]" })
			end,
		},
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

						-- Navigation
						map("n", "]c", function()
							if vim.wo.diff then
								return "]c"
							end
							vim.schedule(function()
								gs.next_hunk()
							end)
							return "<Ignore>"
						end, { expr = true, desc = "Next hunk" })

						map("n", "[c", function()
							if vim.wo.diff then
								return "[c"
							end
							vim.schedule(function()
								gs.prev_hunk()
							end)
							return "<Ignore>"
						end, { expr = true, desc = "Previous hunk" })

						-- Actions
						map(
							{ "n", "x" },
							vim.g.chief_key .. "ghs",
							"<Cmd>Gitsigns stage_hunk<CR>",
							{ desc = "Stage this hunk" }
						)
						map(
							"n",
							vim.g.chief_key .. "ghS",
							gs.stage_buffer,
							{ desc = "Stage all changes in the buffer" }
						)
						map(
							{ "n", "x" },
							vim.g.chief_key .. "ghr",
							"<Cmd>Gitsigns reset_hunk<CR>",
							{ desc = "Restore this hunk to index" }
						)
						map(
							"n",
							vim.g.chief_key .. "ghR",
							gs.reset_buffer,
							{ desc = "Restore all unstaged changes in the buffer to index" }
						)
						map(
							"n",
							vim.g.chief_key .. "ghu",
							gs.undo_stage_hunk,
							{ desc = "Unstage the last staged hunk" }
						)
						map("n", vim.g.chief_key .. "ghp", gs.preview_hunk, { desc = "Preview this hunk" })
						map("n", vim.g.chief_key .. "gb", function()
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
				require("keymap.which-key-helper").register_with_editable("Git", vim.g.chief_key .. "g", vim.g.chief_key, {
					d = { "DiffviewOpen", { desc = "DiffviewOpen" } },
					v = { "DiffviewFileHistory %", { desc = "Diffview history of this file" } },
					V = { "DiffviewFileHistory", { desc = "Diffview history of repository" } },
				})
			end,
		},

		-- look & feel
		-- nvim-web-devicons requires external font such as https://www.nerdfonts.com/
		"nvim-tree/nvim-web-devicons",
		{
			"nvim-lualine/lualine.nvim",
			dependencies = { "nvim-tree/nvim-web-devicons" },
			config = function()
				vim.o.showmode = false

				local function mode_with_paste()
					local lualine_mode_map = require("lualine.utils.mode").map
					local mode = lualine_mode_map[vim.fn.mode()]
					if vim.o.paste then
						mode = mode .. " (PASTE)"
					end
					return mode
				end

				require("lualine").setup({
					options = {
						theme = "ayu_mirage",
						disabled_filetypes = {
							-- statusline = {},
							winbar = { "help", "qf", "gitcommit", "fugitive" },
						},
					},
					sections = {
						lualine_a = { mode_with_paste },
						lualine_b = { "branch", "diff", "diagnostics" },
						lualine_c = { "vim.fn.fnamemodify(vim.fn.getcwd(0), ':~')" },
					},
					inactive_sections = {
						lualine_c = { "vim.fn.fnamemodify(vim.fn.getcwd(0), ':~')" },
						lualine_x = { "location" },
					},
					winbar = {
						lualine_c = { { "filename", path = 1, newfile_status = true } },
					},
					inactive_winbar = {
						lualine_c = { { "filename", path = 1, newfile_status = true } },
					},
					extensions = { "aerial", "man", "nvim-tree", "quickfix", "symbols-outline", "toggleterm" },
				})
			end,
		},

		-- finder (path/dir/file/buffer/tac/etc.)
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
			branch = "v2.x",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
				"MunifTanjim/nui.nvim",
			},
			config = function()
				vim.g.neo_tree_remove_legacy_commands = 1
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
			"kevinhwang91/rnvimr",
			cond = function()
				return vim.fn.executable("ranger")
			end,
			config = function()
				vim.keymap.set("n", "<Leader>e", "<Cmd>RnvimrToggle<CR>", { desc = "ranger" })
				-- Hide the files included in gitignore
				vim.g.rnvimr_hide_gitignore = 1
				vim.g.rnvimr_edit_cmd = "tabedit"
				vim.g.rnvimr_enable_picker = 1
				vim.g.rnvimr_layout = {
					relative = "editor",
					width = vim.o.columns,
					height = vim.o.lines - 3,
					col = 0,
					row = 1,
					style = "minimal",
				}
			end,
		},
		{
			"preservim/tagbar",
			enabled = false,
			config = function()
				vim.keymap.set("n", "<Leader>o", "<Cmd>TagbarToggle<CR>")
				vim.keymap.set("n", "<Leader>O", "<Cmd>TagbarOpen fj<CR>")
			end,
		},
		{
			"simrat39/symbols-outline.nvim",
			config = function()
				local symbols_outline = require("symbols-outline")
				symbols_outline.setup({
					autofold_depth = 0,
				})

				local function is_window_open_in_current_tab(win_id)
					return vim.fn.win_id2win(win_id) ~= 0
				end

				local function is_outline_open_in_current_tab()
					if not symbols_outline.view:is_open() then
						return false
					end
					return is_window_open_in_current_tab(symbols_outline.view.winnr)
				end

				local function symbols_outline_focus()
					if is_outline_open_in_current_tab() then
						vim.fn.win_gotoid(symbols_outline.view.winnr)
						return
					end

					if symbols_outline.view:is_open() then
						symbols_outline.close_outline()
					end

					symbols_outline.open_outline()
				end

				local function symbols_outline_toggle()
					if symbols_outline.view:is_open() then
						symbols_outline.close_outline()
						return
					end

					symbols_outline.open_outline()
				end

				vim.api.nvim_create_user_command("SymbolsOutlineToggle", symbols_outline_toggle, {})
				vim.api.nvim_create_user_command("SymbolsOutlineFocus", symbols_outline_focus, {})
			end,
		},
		{
			"stevearc/aerial.nvim",
			dependencies = {
				{ "neovim/nvim-lspconfig" },
				{ "nvim-telescope/telescope.nvim" },
			},
			config = function()
				require("aerial").setup({
					min_width = 20,
					show_guides = true,
				})
				vim.keymap.set("n", "<Leader>o", function()
					if vim.lsp.buf.server_ready() then
						vim.cmd("SymbolsOutlineToggle")
					else
						vim.cmd("AerialToggle!")
					end
				end)
				vim.keymap.set("n", "<Leader>O", function()
					if vim.lsp.buf.server_ready() then
						vim.cmd("SymbolsOutlineFocus")
					else
						vim.cmd("AerialOpen")
					end
				end)
			end,
		},
		{
			"nvim-telescope/telescope.nvim",
			dependencies = {
				{ "nvim-lua/plenary.nvim" },
				{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
				{ "nvim-telescope/telescope-ghq.nvim" },
				{ "LinArcX/telescope-scriptnames.nvim" },
				{ "brookhong/telescope-pathogen.nvim" },
				{ "princejoogie/dir-telescope.nvim" },
			},
			config = function()
				-- NOTE This does not work properly at the moment...
				-- See https://github.com/nvim-telescope/telescope.nvim/issues/1661
				-- vim.cmd "autocmd User TelescopePreviewerLoaded setlocal number" -- Add line number to preview

				local telescope = require("telescope")
				local action = require("telescope.actions")
				local action_set = require("telescope.actions.set")
				local action_layout = require("telescope.actions.layout")
				local function bottom_pane_borderchars()
					return {
						prompt = { "─", "│", " ", "│", "╭", "╮", "", " " },
						preview = { "─", "│", "─", "│", "╭", "│", "╯", "─" },
						results = { " ", " ", "─", "│", " ", " ", "─", "╰" },
					}
				end
				telescope.load_extension("fzf")
				telescope.load_extension("ghq")
				telescope.load_extension("scriptnames")
				telescope.load_extension("pathogen")
				telescope.load_extension("dir")
				require("dir-telescope").setup({
					no_ignore = true,
				})
				telescope.setup({
					defaults = {
						vimgrep_arguments = {
							"rg",
							"--color=never",
							"--no-heading",
							"--with-filename",
							"--line-number",
							"--column",
							"--smart-case",
							"--hidden",
							"--glob",
							"!.git",
						},
						sorting_strategy = "ascending",
						-- wrap_results = true,
						path_display = { truncate = 1 },
						layout_strategy = "bottom_pane",
						borderchars = bottom_pane_borderchars(),
						layout_config = {
							horizontal = {
								width = 0.95,
								height = 0.95,
								prompt_position = "top",
								preview_width = 0.60,
							},
							bottom_pane = {
								height = 0.99,
								preview_width = 0.60,
							},
							vertical = {
								width = 0.92,
								height = 0.92,
								preview_width = 0.60,
							},
						},
						mappings = {
							n = {
								q = action.close,
								["<C-d>"] = function(bufnr)
									action_set.scroll_results(bufnr, 1)
								end,
								["<C-u>"] = function(bufnr)
									action_set.scroll_results(bufnr, 0)
								end,
								["<M-j>"] = function(bufnr)
									action_set.scroll_previewer(bufnr, 1)
								end,
								["<M-k>"] = function(bufnr)
									action_set.scroll_previewer(bufnr, 0)
								end,
							},
							i = {
								["<Esc>"] = action.close,
								["<C-\\>"] = { "<Esc>", type = "command" },
								["<C-_>"] = action_layout.toggle_preview,
								["<Tab>"] = action.move_selection_worse,
								["<C-j>"] = function(bufnr)
									action.toggle_selection(bufnr)
									action.move_selection_worse(bufnr)
								end,
								["<C-M-j>"] = function(bufnr)
									action.toggle_selection(bufnr)
									action.move_selection_better(bufnr)
								end,
								["<M-<>"] = action.move_to_top,
								["<M->>"] = action.move_to_bottom,
								["<C-d>"] = { "<DEL>", type = "command" },
								["<C-u>"] = { "<C-u>", type = "command" },
								["<M-j>"] = function(bufnr)
									action_set.scroll_previewer(bufnr, 0.5)
								end,
								["<M-k>"] = function(bufnr)
									action_set.scroll_previewer(bufnr, -0.5)
								end,
								["<C-M-n>"] = action.cycle_history_next,
								["<C-M-p>"] = action.cycle_history_prev,
								["<M-?>"] = action.which_key,
							},
						},
					},
					pickers = {
						-- Default configuration for builtin pickers goes here:
						find_files = {
							find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git" },
						},
						oldfiles = {
							layout_config = { preview_width = 0.5 },
						},
						live_grep = {
							layout_config = { preview_width = 0.5 },
						},
						grep_string = {
							layout_config = { preview_width = 0.5 },
						},
						-- Now the picker_config_key will be applied every time you call this
						-- builtin picker
					},
					extensions = {
						-- Your extension configuration goes here:
						-- extension_name = {
						--   extension_config_key = value,
						-- }
						-- please take a look at the readme of the extension you want to configure
					},
				})

				require("keymap.which-key-helper").register_with_editable(
					"Telescope",
					vim.g.chief_key .. "f",
					vim.g.chief_key,
					{
						b = { 'lua require("telescope.builtin").buffers()', { desc = "Buffers" } },
						c = { 'lua require("telescope.builtin").git_bcommits()', { desc = "Git buffer commits" } },
						C = { 'lua require("telescope.builtin").git_commits()', { desc = "Git commits" } },
						d = { 'lua require("telescope.builtin").diagnostics()', { desc = "Diagnostics" } },
						e = {
							'lua require("pathogen").browse_file({ cwd = vim.fs.dirname(vim.api.nvim_buf_get_name(0)) })',
							{ desc = "File browser" },
						},
						f = { 'lua require("pathogen").find_files()', { desc = "Files" } },
						g = { 'lua require("telescope.builtin").git_files()', { desc = "Git files" } },
						G = { 'lua require("telescope.builtin").git_status()', { desc = "Git status" } },
						h = { 'lua require("telescope.builtin").help_tags()', { desc = "Help tags" } },
						H = { 'lua require("telescope.builtin").highlights()', { desc = "Highlights" } },
						k = { 'lua require("telescope.builtin").keymaps()', { desc = "Keymaps" } },
						l = {
							'lua require("telescope.builtin").current_buffer_fuzzy_find()',
							{ desc = "Buffer lines" },
						},
						m = { 'lua require("telescope.builtin").marks()', { desc = "Marks" } },
						o = { 'lua require("telescope.builtin").treesitter()', { desc = "Treesitter" } },
						O = { 'lua require("telescope.builtin").oldfiles()', { desc = "Oldfiles" } },
						q = {
							'lua require("telescope").extensions.ghq.list({ layout_config = { preview_width = 0.5 } })',
							{ desc = "Ghq list" },
						},
						r = { 'lua require("pathogen").live_grep()', { desc = "Grep" } },
						R = {
							'lua require("telescope").extensions.dir.live_grep()',
							{ desc = "Pick directory + Grep" },
						},
						s = { 'lua require("telescope.builtin").spell_suggest()', { desc = "Spell suggest" } },
						S = {
							'lua require("telescope").extensions.scriptnames.scriptnames()',
							{ desc = "Scriptnames" },
						},
						y = {
							'lua require("telescope").extensions.yank_history.yank_history()',
							{ desc = "Yank history" },
						},
						[":"] = { 'lua require("telescope.builtin").command_history()', { desc = "Command history" } },
						["/"] = { 'lua require("telescope.builtin").search_history()', { desc = "Search history" } },
					}
				)
			end,
		},

		-- moving around
		{
			"ggandor/leap.nvim",
			dependencies = {
				{ "ggandor/flit.nvim" },
			},
			config = function()
				local direction_forward = "forward"
				local direction_backward = "backward"
				local function get_jump_targets(opts)
					opts = opts or {}

					local wininfo = vim.fn.getwininfo(opts.winid)[1]
					local cur_line = vim.fn.line(".")
					local cur_col = vim.fn.col(".")

					local function get_start_end_lnum()
						-- if opts.direction == 'forward' then
						if opts.direction == direction_forward then
							return cur_line, wininfo.botline
						end

						if opts.direction == direction_backward then
							return wininfo.topline, cur_line
						end

						return wininfo.topline, wininfo.botline
					end

					-- Get targets.
					local targets = {}
					local start_lnum, end_lnum = get_start_end_lnum()
					local lnum = start_lnum
					while lnum <= end_lnum do
						local fold_end = vim.fn.foldclosedend(lnum)
						-- Skip folded ranges.
						if fold_end ~= -1 then
							lnum = fold_end + 1
						else
							local cnum = math.min(cur_col, string.len(vim.fn.getline(lnum)))
							if lnum ~= cur_line then
								table.insert(targets, { pos = { lnum, cnum } })
							end
							lnum = lnum + 1
						end
					end
					-- Sort them by vertical screen distance from cursor.
					local cur_screen_row = vim.fn.screenpos(opts.winid, cur_line, 1)["row"]
					local function screen_rows_from_cur(t)
						local t_screen_row = vim.fn.screenpos(opts.winid, t.pos[1], t.pos[2])["row"]
						return math.abs(cur_screen_row - t_screen_row)
					end
					table.sort(targets, function(t1, t2)
						return screen_rows_from_cur(t1) < screen_rows_from_cur(t2)
					end)

					if #targets >= 1 then
						return targets
					end
				end

				local function leap_to_line(opts)
					opts = opts or {}
					local winid = vim.api.nvim_get_current_win()
					opts.winid = winid

					local leap_opts = {}
					if opts.direction == nil then
						leap_opts.target_windows = { winid }
					elseif opts.direction == direction_backward then
						leap_opts.backward = true
					end
					leap_opts.targets = get_jump_targets(opts)

					require("leap").leap(leap_opts)
				end

				require("leap").opts.max_phase_one_targets = 0
				require("leap").opts.safe_labels = { "s", "f", "n", "u", "t", "w", "b", "e", "o" }
				require("leap").opts.labels = {
					"s",
					"f",
					"n",
					"j",
					"k",
					"l",
					"h",
					"o",
					"d",
					"w",
					"e",
					"m",
					"b",
					"u",
					"y",
					"v",
					"r",
					"g",
					"t",
					"c",
					"x",
					"z",
				}

				vim.keymap.set({ "n", "x", "o" }, "<Plug>(leap-forward-line)", function()
					leap_to_line({ direction = direction_forward })
				end)
				vim.keymap.set({ "n", "x", "o" }, "<Plug>(leap-backward-line)", function()
					leap_to_line({ direction = direction_backward })
				end)

				-- vim.keymap.set({ 'n', 'x', 'o' }, 's',
				--   function() require('leap').leap { target_windows = { vim.fn.win_getid() } } end)
				-- vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap-forward-to)')
				-- vim.keymap.set({ 'n', 'x', 'o' }, 'x', '<Plug>(leap-backward-to)')
				vim.keymap.set({ "n", "x" }, "gj", "<Plug>(leap-forward-line)")
				vim.keymap.set({ "n", "x" }, "gk", "<Plug>(leap-backward-line)")
				vim.keymap.set({ "o" }, "gj", "V<Plug>(leap-forward-line)")
				vim.keymap.set({ "o" }, "gk", "V<Plug>(leap-backward-line)")

				require("flit").setup({
					labeled_modes = "nvo",
					multiline = false,
				})
			end,
		},
		{
			"rlane/pounce.nvim",
			config = function()
				require("pounce").setup({
					multi_window = false,
				})
				vim.keymap.set("n", "s", function()
					require("pounce").pounce({})
				end)
				vim.keymap.set("n", "S", function()
					require("pounce").pounce({ do_repeat = true })
				end)
				vim.keymap.set("x", "s", function()
					require("pounce").pounce({})
				end)
				vim.keymap.set("o", "s", function()
					require("pounce").pounce({})
				end)
			end,
		},
		{
			"phaazon/hop.nvim",
			enabled = false,
			config = function()
				local hop = require("hop")
				hop.setup({
					uppercase_labels = true,
				})
				local hop_hint = require("hop.hint")
				local function hop_forward_to()
					hop.hint_char1({
						direction = hop_hint.HintDirection.AFTER_CURSOR,
						current_line_only = true,
						hint_offset = -1,
					})
				end

				local function hop_backward_to()
					hop.hint_char1({
						direction = hop_hint.HintDirection.BEFORE_CURSOR,
						current_line_only = true,
						hint_offset = 1,
					})
				end

				---@diagnostic disable-next-line: unused-local,unused-function
				local function hop_forward_words_end()
					hop.hint_words({
						direction = hop_hint.HintDirection.AFTER_CURSOR,
						hint_position = hop_hint.HintPosition.END,
						current_line_only = true,
					})
				end

				---@diagnostic disable-next-line: unused-local,unused-function
				local function hop_backword_words_end()
					hop.hint_words({
						direction = hop_hint.HintDirection.BEFORE_CURSOR_CURSOR,
						hint_position = hop_hint.HintPosition.END,
						current_line_only = true,
					})
				end

				vim.keymap.set({ "n", "x", "o" }, "f", "<Cmd>HopChar1CurrentLineAC<CR>")
				vim.keymap.set({ "n", "x", "o" }, "F", "<Cmd>HopChar1CurrentLineBC<CR>")
				-- vim.keymap.set({ 'n', 'x', 'o' }, 'sw', "<Cmd>HopWordAC<CR>")
				-- vim.keymap.set({ 'n', 'x', 'o' }, 'sb', "<Cmd>HopWordBC<CR>")
				-- vim.keymap.set({ 'n', 'x', 'o' }, 'se', hop_forward_words_end)
				-- vim.keymap.set({ 'n', 'x', 'o' }, 'sge', hop_backword_words_end)
				vim.keymap.set({ "n", "x" }, "gj", "<Cmd>HopVerticalAC<CR>")
				vim.keymap.set({ "n", "x" }, "gk", "<Cmd>HopVerticalBC<CR>")
				vim.keymap.set("o", "gj", "V<Cmd>HopVerticalAC<CR>")
				vim.keymap.set("o", "gk", "V<Cmd>HopVerticalBC<CR>")
				vim.keymap.set({ "n", "x", "o" }, "s", "<Cmd>HopPatternAC<CR>")
				vim.keymap.set({ "n", "x", "o" }, "<Leader>s", "<Cmd>HopPatternBC<CR>")
				vim.keymap.set("o", "t", hop_forward_to)
				vim.keymap.set("o", "T", hop_backward_to)

				-- repeating is not implemented yet
				-- map s. <Plug>(easymotion-repeat)
				-- map <Bslash> <Plug>(easymotion-next)
				-- map <Bar> <Plug>(easymotion-prev)
			end,
		},
		{
			"liangxianzhe/nap.nvim",
			config = function()
				require("nap").setup({
					next_repeat = "<M-n>",
					prev_repeat = "<M-p>",
					operators = {
						["<C-d>"] = {
							next = { command = vim.diagnostic.goto_next, desc = "Next diagnostic" },
							prev = { command = vim.diagnostic.goto_prev, desc = "Prev diagnostic" },
							mode = { "n", "v", "o" },
						},
						["<C-l>"] = {
							next = { command = "lnext", desc = "Next loclist item" },
							prev = { command = "lprevious", desc = "Prev loclist item" },
						},
						["<C-q>"] = {
							next = { command = "cnext", desc = "Next quickfix item" },
							prev = { command = "cprevious", desc = "Prev quickfix item" },
						},
					},
				})
			end,
		},
		{
			"chrisgrieser/nvim-spider",
			config = function()
				require("spider").setup({
					skipInsignificantPunctuation = false,
				})
				vim.keymap.set(
					{ "n", "o", "x" },
					"<M-w>",
					"<Cmd>lua require('spider').motion('w')<CR>",
					{ desc = "Spider-w" }
				)
				-- vim.keymap.set({ "n", "o", "x" }, "<M-e>", "<Cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
				vim.keymap.set(
					{ "n", "o", "x" },
					"<M-b>",
					"<Cmd>lua require('spider').motion('b')<CR>",
					{ desc = "Spider-b" }
				)
				-- vim.keymap.set({ "n", "o", "x" }, "<M-g><M-e>", "<Cmd>lua require('spider').motion('ge')<CR>",
				--   { desc = "Spider-ge" })
			end,
		},
		{
			"chrisgrieser/nvim-various-textobjs",
			config = function()
				require("various-textobjs").setup({
					lookForwardLines = 0, -- set to 0 to only look in the current line
				})
				vim.keymap.set(
					{ "o", "x" },
					"ii",
					'<Cmd>lua require("various-textobjs").indentation(true, true)<CR>',
					{ desc = "An indentation block" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"ai",
					'<Cmd>lua require("various-textobjs").indentation(false, true)<CR>',
					{ desc = "An indentation block + line above" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"iI",
					'<Cmd>lua require("various-textobjs").indentation(true, false)<CR>',
					{ desc = "An indentation block + line below" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"aI",
					'<Cmd>lua require("various-textobjs").indentation(false, false)<CR>',
					{ desc = "An indentation block + line above/below" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"im",
					'<Cmd>lua require("various-textobjs").subword(true)<CR>',
					{ desc = "Subword (inner)" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"am",
					'<Cmd>lua require("various-textobjs").subword(false)<CR>',
					{ desc = "Subword (outer)" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"gG",
					'<Cmd>lua require("various-textobjs").entireBuffer()<CR>',
					{ desc = "Entire buffer" }
				)
				vim.keymap.set(
					{ "o" },
					"u",
					'<Cmd>lua require("various-textobjs").lineCharacterwise()<CR>',
					{ desc = "Whole line without indent" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"gl",
					"<Cmd>lua require('various-textobjs').nearEoL()<CR>",
					{ desc = "To EoL - 1" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"iv",
					'<Cmd>lua require("various-textobjs").value(true)<CR>',
					{ desc = "Value of key-value pair (inner)" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"av",
					'<Cmd>lua require("various-textobjs").value(false)<CR>',
					{ desc = "Value of key-value pair (outer)" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"ik",
					'<Cmd>lua require("various-textobjs").key(true)<CR>',
					{ desc = "Key of key-value pair (inner)" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"ak",
					'<Cmd>lua require("various-textobjs").key(false)<CR>',
					{ desc = "Key of key-value pair (outer)" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"ie",
					'<Cmd> lua require("various-textobjs").chainMember(true) <CR>',
					{ desc = "Chain member (inner)" }
				)
				vim.keymap.set(
					{ "o", "x" },
					"ae",
					'<Cmd>lua require("various-textobjs").chainMember(false)<CR>',
					{ desc = "Chain member (outer)" }
				)
			end,
		},

		-- editting
		{
			"gbprod/yanky.nvim",
			dependencies = {
				{ "nvim-telescope/telescope.nvim" },
			},
			config = function()
				local utils = require("yanky.utils")
				local mapping = require("yanky.telescope.mapping")
				require("yanky").setup({
					highlight = {
						on_put = false,
						on_yank = false,
					},
					picker = {
						telescope = {
							mappings = {
								default = mapping.put("p"),
								i = {
									["<M-CR>"] = mapping.put("P"),
									["<c-k>"] = mapping.delete(),
									["<c-r>"] = mapping.set_register(utils.get_default_register()),
								},
								n = {
									p = mapping.put("p"),
									P = mapping.put("P"),
									d = mapping.delete(),
									r = mapping.set_register(utils.get_default_register()),
								},
							},
						},
					},
				})
				vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")
				vim.keymap.set({ "n", "x" }, "P", "<Plug>(YankyPutBefore)")
				vim.keymap.set({ "n", "x" }, "gp", "<Plug>(YankyGPutAfter)")
				vim.keymap.set({ "n", "x" }, "gP", "<Plug>(YankyGPutBefore)")
				vim.keymap.set("n", "<M-p>", "<Plug>(YankyCycleForward)")
				vim.keymap.set("n", "<M-P>", "<Plug>(YankyCycleBackward)")
			end,
		},
		"gpanders/editorconfig.nvim",
		{
			"lukas-reineke/indent-blankline.nvim",
			config = function()
				vim.api.nvim_set_hl(0, "IndentBlanklineChar", { ctermfg = 59 })
				vim.api.nvim_set_hl(0, "IndentBlanklineSpaceChar", {}) -- this highlight overlaps cursorline. set None to prevent it.

				require("indent_blankline").setup({
					char = "¦",
					show_first_indent_level = false,
					filetype_exclude = { "help", "markdown", "json", "nerdtree", "NvimTree", "man" },
				})
			end,
		},
		{
			"numToStr/Comment.nvim",
			config = function()
				local ft = require("Comment.ft")
				require("Comment").setup({
					ignore = "^$",
					ft.set("asciidoc", { "//%s", "////%s////" }),
				})
				-- XXX not working
				-- vim.keymap.set('i', '<C-\\>', '<C-o>gcc', { remap = true, silent = true } )
				vim.keymap.set("n", "gcy", "yy<Plug>(comment_toggle_linewise_current)", { silent = true })
				vim.keymap.set("x", "gCy", "ygv<Plug>(comment_toggle_linewise_visual)", { silent = true })
			end,
		},
		{
			"preservim/nerdcommenter",
			enabled = false,
			config = function()
				vim.g.NERDSpaceDelims = 1 -- Add spaces after comment delimiters
				vim.g.NERDDefaultAlign = "left"
				vim.keymap.set({ "n", "x", "i" }, "<C-\\>", "<Plug>NERDCommenterToggle")
			end,
		},
		{
			"gbprod/substitute.nvim",
			dependencies = {
				{ "gbprod/yanky.nvim" },
			},
			config = function()
				require("substitute").setup({
					highlight_substituted_text = {
						enabled = false,
					},
					range = {
						prefix = "substitute",
						prompt_current_text = true,
						confirm = true,
					},
				})
				vim.keymap.set(
					"n",
					"cp",
					require("substitute").operator,
					{ desc = "Replace operator text with yanked text" }
				)
				vim.keymap.set("n", "cpp", function()
					require("substitute").operator({ motion = "iw" })
				end, { desc = "Replace operator text with yanked text" })
				-- vim.keymap.set('n', 'cpp', require('substitute').line, { desc = 'Replace whole line with yanked text' })
				-- vim.keymap.set('n', 'cP', require('substitute').eol, { desc = 'Replace text to EOL with yanked text' })
				vim.keymap.set(
					"x",
					"cp",
					require("substitute").visual,
					{ desc = "Replace visual text with yanked text" }
				)

				vim.keymap.set(
					"n",
					"<Leader>c",
					require("substitute.range").operator,
					{ desc = "Substitute operator text within the range" }
				)
				vim.keymap.set(
					"x",
					"<Leader>c",
					require("substitute.range").visual,
					{ desc = "Substitute visual text within the range" }
				)
				-- vim.keymap.set('n', '<Leader>cc', require('substitute.range').word,
				--   { desc = 'Substitute cursor word within the range' })
				vim.keymap.set("n", "<Leader>cc", function()
					require("substitute.range").operator({ motion1 = "iw" })
				end, { desc = "Substitute cursor word within the range" })

				vim.keymap.set("n", "cx", require("substitute.exchange").operator, { desc = "Swap operator text" })
				vim.keymap.set("n", "cxx", function()
					require("substitute.exchange").operator({ motion = "iw" })
				end, { desc = "Swap cursor word" })
				-- vim.keymap.set('n', 'cxx', require('substitute.exchange').line), { desc = 'Swap whole line'}
				vim.keymap.set("x", "X", require("substitute.exchange").visual, { desc = "Swap visual text" })
				vim.keymap.set("n", "cxc", require("substitute.exchange").cancel, { desc = "Cancel swapping text" })
			end,
		},
		{
			"johmsalas/text-case.nvim",
			dependencies = {
				{ "folke/which-key.nvim" },
			},
			config = function()
				local textcase = require("textcase")
				local prefix = "ga"
				local key_api_table = {
					u = textcase.api.to_upper_case,
					l = textcase.api.to_lower_case,
					s = textcase.api.to_snake_case,
					h = textcase.api.to_dash_case,
					n = textcase.api.to_constant_case,
					d = textcase.api.to_dot_case,
					a = textcase.api.to_phrase_case,
					c = textcase.api.to_camel_case,
					p = textcase.api.to_pascal_case,
					t = textcase.api.to_title_case,
					f = textcase.api.to_path_case,
				}
				for key, api in pairs(key_api_table) do
					textcase.register_keybindings(prefix, api, {
						quick_replace = key,
						operator = "o" .. key,
						visual = key,
					})
				end

				local wk = require("which-key")
				wk.register({
					[prefix] = {
						name = "text-case",
					},
				}, { mode = "v" })

				wk.register({
					[prefix] = {
						name = "text-case",
						o = {
							name = "Pending mode operator",
						},
					},
				}, { mode = "n" })
			end,
		},
		{
			"arthurxavierx/vim-caser",
			enabled = false,
		},
		{
			"kylechui/nvim-surround",
			version = "*", -- Use for stability; omit to use `main` branch for the latest features
			config = function()
				require("nvim-surround").setup({
					keymaps = {
						insert = false,
						insert_line = false,
						normal = "yr",
						normal_cur = "yrr",
						normal_line = "yR",
						normal_cur_line = "yRR",
						visual = "R",
						visual_line = "gR",
						delete = "dr",
						change = "cr",
					},
					surrounds = {
						["d"] = {
							---@diagnostic disable-next-line: assign-type-mismatch
							add = { "${", "}" },
							find = function()
								return require("nvim-surround.config").get_selection({ pattern = "%${[^}]*}" })
							end,
							---@diagnostic disable-next-line: assign-type-mismatch
							delete = "^(..)().-(.)()$",
							change = {
								---@diagnostic disable-next-line: assign-type-mismatch
								target = "(%${)()[^}]*(})()",
							},
						},
						["D"] = {
							---@diagnostic disable-next-line: assign-type-mismatch
							add = { '"${', '}"' },
							find = function()
								return require("nvim-surround.config").get_selection({ pattern = '"%${[^}]*}"' })
							end,
							---@diagnostic disable-next-line: assign-type-mismatch
							delete = "^(...)().-(..)()$",
							change = {
								---@diagnostic disable-next-line: assign-type-mismatch
								target = '("%${)()[^}]*(}")()',
							},
						},
						-- XXX this one is not working properly (delete/change edits parentheses only)
						["s"] = {
							---@diagnostic disable-next-line: assign-type-mismatch
							add = { "$(", ")" },
							find = function()
								return require("nvim-surround.config").get_selection({ pattern = "%$%([^)]*%)" })
							end,
							---@diagnostic disable-next-line: assign-type-mismatch
							delete = "^(..)().-(.)()$",
							change = {
								---@diagnostic disable-next-line: assign-type-mismatch
								target = "^(%$%())()[^)]*(%))()$",
							},
						},
						["S"] = {
							---@diagnostic disable-next-line: assign-type-mismatch
							add = { '"$(', ')"' },
							find = function()
								return require("nvim-surround.config").get_selection({ pattern = '"%$%([^)]*%)"' })
							end,
							---@diagnostic disable-next-line: assign-type-mismatch
							delete = "^(...)().-(..)()$",
							change = {
								---@diagnostic disable-next-line: assign-type-mismatch
								target = '^("%$%()()[^)]*(%)")()$',
							},
						},
					},
				})
			end,
		},
		{
			"windwp/nvim-autopairs",
			config = function()
				local ap = require("nvim-autopairs")
				local Rule = require("nvim-autopairs.rule")
				ap.setup({
					map_c_h = true,
					map_c_w = true,
					fast_wrap = {
						map = "<M-p>",
						keys = "asdfghjklqwertyuiopzxcvbnm",
						end_keys = ";",
					},
				})
				ap.remove_rule("'")
				ap.add_rules({
					Rule("<", ">", { "rust" }),
					Rule("'", "'", { "-rust" }),
				})
			end,
		},
		{
			"jiangmiao/auto-pairs",
			enabled = false,
			config = function()
				vim.g.AutoPairsShortcutToggle = ""
				vim.g.AutoPairsShortcutFastWrap = "<M-p>"
				vim.g.AutoPairsShortcutJump = "<M-n>"
				vim.g.AutoPairsShortcutBackInsert = "<M-\\>"
				vim.g.AutoPairsMapSpace = 0 -- Enabling this maps <Space> to <C-]><C-R>=... and <C-]> is unwanted
				vim.g.AutoPairsMultilineClose = 0
				vim.keymap.set("i", "<Space>", "<C-g>u<C-r>=AutoPairsSpace()<CR>", { silent = true })
			end,
		},
		{
			"Wansmer/treesj",
			dependencies = { "nvim-treesitter" },
			config = function()
				require("treesj").setup({
					use_default_keymaps = false,
				})
				vim.keymap.set("n", "gS", "<Cmd>TSJToggle<CR>")
			end,
		},
		"tpope/vim-repeat",
		{
			"neovim/nvim-lspconfig",
			config = function()
				-- 'java': [$HOME.'/toybox/vim/helper/java-lsp.sh', '-data', getcwd()],
				-- 'javascript': ['typescript-language-server', '--stdio'],
				-- 'php': [s:plugin_dir . '/phpactor/bin/phpactor', 'language-server'],

				vim.cmd([[highlight link NormalFloat Normal]])
				-- vim.lsp.set_log_level("debug")

				local lspconfig = require("lspconfig")
				local capabilities = vim.lsp.protocol.make_client_capabilities()
				capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)
				capabilities.textDocument.completion.completionItem.resolveSupport = {
					properties = {
						"documentation",
						"detail",
						"additionalTextEdits",
					},
				}

				-- Set border for floating window
				-- This does not work
				-- LSP settings (for overriding per client)
				-- local handlers =  {
				--   ["textDocument/hover"] =  vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
				--   ["textDocument/signatureHelp"] =  vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
				-- }
				local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
				function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
					opts = opts or {}
					opts.border = opts.border or "rounded"
					-- opts.max_width = opts.border or 100 -- <- this causes error
					opts.max_width = 100
					return orig_util_open_floating_preview(contents, syntax, opts, ...)
				end

				-- setup for rust-analyzer is done by rust-tools as it handles better
				local servers = { "gopls", "pyright", "rust_analyzer", "lua_ls" }
				for _, lsp in pairs(servers) do
					lspconfig[lsp].setup({
						capabilities = capabilities,
					})
				end
				lspconfig["lua_ls"].setup({
					settings = {
						Lua = {
							runtime = {
								-- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								globals = { "vim" },
							},
							workspace = {
								-- Make the server aware of Neovim runtime files
								library = vim.api.nvim_get_runtime_file("", true),
								checkThirdParty = false,
							},
							-- Do not send telemetry data containing a randomized but unique identifier
							telemetry = {
								enable = false,
							},
							format = {
								enable = true,
								-- Put format options here
								-- NOTE: the value should be STRING!!
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
								},
							},
						},
					},
				})

				vim.keymap.set(
					"i",
					"<C-x><C-h>",
					"<Cmd>lua vim.lsp.buf.signature_help()<CR>",
					{ desc = "Signature help" }
				)
				vim.keymap.set("n", "<C-]>", "<Cmd>lua vim.lsp.buf.definition()<CR>", { desc = "Definition" })
				vim.keymap.set("n", "g<C-]>", "<Cmd>lua vim.lsp.buf.implementation<CR>", { desc = "Implementation" })
				vim.keymap.set(
					"n",
					"<C-w><C-]>",
					"<Cmd>split | lua vim.lsp.buf.definition()<CR>",
					{ desc = "Definition [horz]" }
				)
				vim.keymap.set(
					"n",
					"<C-w><C-g><C-]>",
					"<Cmd>split | lua vim.lsp.buf.implementation<CR>",
					{ desc = "Implementation [horz]" }
				)
				vim.keymap.set(
					"n",
					"[Vert]<C-]>",
					"<Cmd>vertical split | lua vim.lsp.buf.definition()<CR>",
					{ desc = "Definition [vert]" }
				)
				vim.keymap.set(
					"n",
					"[Vert]<C-g><C-]>",
					"<Cmd>vertical split | lua vim.lsp.buf.implementation<CR>",
					{ desc = "Implementation [vert]" }
				)
				vim.keymap.set(
					"n",
					"<C-t><C-]>",
					"<Cmd>tab split | lua vim.lsp.buf.definition()<CR>",
					{ desc = "Definition [tab]" }
				)
				vim.keymap.set(
					"n",
					"<C-t><C-g><C-]>",
					"<Cmd>tab split | lua vim.lsp.buf.implementation<CR>",
					{ desc = "Implementation [tab]" }
				)

				require("keymap.which-key-helper").register_with_editable("LSP", vim.g.chief_key .. "s", vim.g.chief_key, {
					a = { "lua vim.lsp.buf.code_action()", { desc = "Code action" } },
					c = { "lua vim.lsp.buf.incoming_calls()", { desc = "Incoming calls" } },
					C = { "lua vim.lsp.buf.outgoing_calls()", { desc = "Outgoing calls" } },
					d = { "lua vim.diagnostic.setloclist()", { desc = "Diagnostic" } },
					f = { "lua vim.lsp.buf.format({ async = true })", { desc = "Format" } },
					F = { 'lua require("lsp").toggle_auto_format()', { desc = "Toggle auto format", silent = true } },
					h = { "lua vim.lsp.buf.hover()", { desc = "Hover" } },
					i = { "lua vim.lsp.buf.implementation()", { desc = "Implementation" } },
					l = { "lua vim.lsp.codelens.run()", { desc = "Code lens" } },
					n = { "lua vim.lsp.buf.rename()", { desc = "Rename" } },
					r = { "lua vim.lsp.buf.references()", { desc = "References" } },
				})
			end,
		},
		{
			"hrsh7th/nvim-cmp",
			dependencies = {
				{ "hrsh7th/cmp-nvim-lsp" },
				{ "hrsh7th/cmp-buffer" },
				{ "hrsh7th/cmp-path" },
				{ "hrsh7th/cmp-cmdline" },
			},
			config = function()
				local cmp = require("cmp")
				local function close_and_fallback(fallback)
					if cmp.visible() then
						cmp.close()
					end
					fallback()
				end

				local function cmp_visible_or_fallback(action)
					return function(fallback)
						if cmp.visible() then
							action()
							return
						end
						fallback()
					end
				end

				cmp.setup({
					snippet = {
						-- REQUIRED - you must specify a snippet engine
						expand = function(args)
							-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
							require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
							-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
							-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
						end,
					},
					window = {
						completion = cmp.config.window.bordered(),
						documentation = cmp.config.window.bordered(),
					},
					mapping = {
						["<M-j>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
						["<M-k>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
						["<Tab>"] = cmp.mapping(function()
							if cmp.visible() then
								cmp.select_next_item()
							else
								cmp.complete()
							end
						end, { "i", "c" }),
						["<M-Tab>"] = cmp.mapping(cmp_visible_or_fallback(cmp.select_prev_item), { "i", "c" }),
						["<C-n>"] = cmp.mapping({
							i = cmp_visible_or_fallback(cmp.select_next_item),
							c = function(fallback)
								if cmp.visible() and cmp.get_active_entry() ~= nil then
									cmp.select_next_item()
								else
									fallback()
								end
							end,
						}),
						["<C-p>"] = cmp.mapping({
							i = cmp_visible_or_fallback(cmp.select_prev_item),
							c = function(fallback)
								if cmp.visible() and cmp.get_active_entry() ~= nil then
									cmp.select_prev_item()
								else
									fallback()
								end
							end,
						}),
						["<C-g>"] = cmp.mapping(cmp.mapping.abort(), { "i", "c" }),
						["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
						["<C-o>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
						["<C-a>"] = cmp.mapping(close_and_fallback, { "i", "c" }),
						["<C-e>"] = cmp.mapping(close_and_fallback, { "i", "c" }),
						["<C-k>"] = cmp.mapping(cmp_visible_or_fallback(cmp.abort), { "i", "c" }),
						["<C-x><C-n>"] = cmp.mapping(function()
							cmp.complete({ config = { sources = { { name = "buffer" } } } })
						end, { "i", "c" }),
					},
					sources = cmp.config.sources({
						{ name = "nvim_lsp" },
						{ name = "luasnip" },
					}, {
						{ name = "buffer" },
					}),
				})

				-- Set configuration for specific filetype.
				-- cmp.setup.filetype('gitcommit', {
				--   sources = cmp.config.sources({
				--     { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you installed it.
				--   }, {
				--     { name = 'buffer' },
				--   })
				-- })

				-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline("/", { sources = { { name = "buffer" } } })

				-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
				cmp.setup.cmdline(
					":",
					{ sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) }
				)

				local spell_suggest = {}
				function spell_suggest:complete(params, callback)
					local source = {}
					-- the pattern only works for the last word of the line
					local spells = vim.fn.spellsuggest(string.match(params.context.cursor_line, "[%a%d]*$"))
					vim.tbl_map(function(spell)
						vim.list_extend(source, { { label = spell } })
					end, spells)
					callback(source)
				end

				cmp.register_source("spell_suggest", spell_suggest)
				vim.keymap.set("i", "<C-x><C-s>", function()
					cmp.complete({ config = { sources = { { name = "spell_suggest" } } } })
				end, { desc = "Spell suggest" })
			end,
		},
		{
			"ray-x/lsp_signature.nvim",
			config = function()
				require("lsp_signature").setup({
					hint_prefix = "🦆 ",
				})
			end,
		},
		{
			"L3MON4D3/LuaSnip",
			version = "v1.*",
			dependencies = {
				{ "rafamadriz/friendly-snippets" },
				{ "saadparwaiz1/cmp_luasnip" },
			},
			config = function()
				require("luasnip").config.setup({ store_selection_keys = "<C-]>" })
				-- Both sources can be enabled at the same time
				local ls_vscode = require("luasnip.loaders.from_vscode")
				ls_vscode.lazy_load() -- enable LSP style snippets
				-- require("luasnip.loaders.from_snipmate").lazy_load()

				vim.keymap.set({ "i", "s" }, "<C-]>", "<Plug>luasnip-expand-or-jump")
				vim.keymap.set({ "i", "s" }, "<C-s>", "<Plug>luasnip-jump-next")
				vim.keymap.set({ "i", "s" }, "<M-s>", "<Plug>luasnip-jump-prev")
				vim.keymap.set("s", "<Tab>", "<Esc>i", { noremap = true })
				vim.keymap.set("s", "<C-a>", "<Esc>a", { noremap = true })

				vim.api.nvim_create_user_command("LuaSnipLoadSnippetsVSCode", ls_vscode.load, {})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
					ensure_installed = {
						"bash",
						"fish",
						"go",
						"hcl",
						"json",
						"lua",
						"make",
						"proto",
						"python",
						"rust",
						"toml",
						"vim",
						"yaml",
					},
					highlight = {
						enable = true,
					},
				})
				-- require('nvim-treesitter.highlight').set_custom_captures({
				--   operator = "Special",
				--   namespace = "TSNone",
				--   ["function"] = "Include",
				--   ["function.call"] = "TSFunction",
				--   ["function.builtin"] = "TSFunction",
				--   ["method"] = "Include",
				--   ["method.call"] = "TSMethod",
				--   variable = "Normal",
				--   parameter = "Normal",
				--   field = "TSNone", -- field of struct initialisation
				--   property = "TSNone", -- field of struct definition, but this affects the property after `.` like time.Second
				-- })
				vim.wo.foldmethod = "expr"
				vim.wo.foldexpr = "nvim_treesitter#foldexpr()"
				vim.wo.foldlevel = 99
			end,
			build = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
		},
		{
			"IndianBoy42/tree-sitter-just",
			dependencies = { "nvim-treesitter/nvim-treesitter" },
		},
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			dependencies = "nvim-treesitter/nvim-treesitter",
			config = function()
				require("nvim-treesitter.configs").setup({
					textobjects = {
						select = {
							enable = true,
							keymaps = {
								["aa"] = "@assignment.outer",
								["ia"] = "@assignment.inner",
								["aA"] = "@assignment.rhs",
								["iA"] = "@assignment.lhs",
								["ac"] = "@call.outer",
								["ic"] = "@call.inner",
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["aF"] = "@frame.outer",
								["iF"] = "@frame.inner",
								["al"] = "@loop.outer",
								["il"] = "@loop.inner",
								["aM"] = "@comment.outer",
								["iM"] = "@comment.inner",
								["an"] = "@return.outer",
								["in"] = "@return.inner",
								["iN"] = "@number.inner",
								["ao"] = "@block.outer",
								["io"] = "@block.inner",
								["ap"] = "@parameter.outer",
								["ip"] = "@parameter.inner",
								["iP"] = "@scopename.inner",
								["ar"] = "@conditional.outer",
								["ir"] = "@conditional.inner",
								["as"] = "@class.outer",
								["is"] = "@class.inner",
								["at"] = "@statement.outer",
								["it"] = "@statement.inner",
								["aT"] = "@attribute.outer",
								["iT"] = "@attribute.inner",
								["ax"] = "@regex.outer",
								["ix"] = "@regex.inner",
							},
						},
					},
				})
			end,
		},
		{
			"nvim-treesitter/nvim-treesitter-context",
		},
		"vim-utils/vim-husk",

		-- misc
		{
			"jose-elias-alvarez/null-ls.nvim",
			dependencies = { "nvim-lua/plenary.nvim" },
			config = function()
				local null_ls = require("null-ls")
				null_ls.setup({
					sources = {
						-- go
						null_ls.builtins.diagnostics.golangci_lint,
						-- lua
						null_ls.builtins.formatting.stylua,
						-- yaml
						null_ls.builtins.diagnostics.yamllint,
						null_ls.builtins.formatting.yamlfmt,
					},
				})
			end,
		},
		{
			"kevinhwang91/nvim-bqf",
		},
		{
			"ahmedkhalf/project.nvim",
			config = function()
				require("project_nvim").setup({
					-- Add some language specific files as project.nvim depends on lsp, it cd into different directory if the current buffer is not supported by lsp.
					patterns = vim.list_extend(
						require("project_nvim.config").defaults.patterns,
						{ "go.mod", "Cargo.toml" }
					),
					scope_chdir = "win",
				})
			end,
		},
		{
			"sheerun/vim-polyglot",
			-- init = function()
			--   vim.g.polyglot_disabled = { 'markdown' }
			-- end,
		},
		{
			"tpope/vim-abolish",
			config = function()
				vim.g.abolish_no_mappings = 1
			end,
		},
		{
			"vim-test/vim-test",
			enabled = false,
			config = function()
				-- By default, tab is opened left to the current tab, and that makes
				-- closing the test tab focus the tab left to the original tab.
				-- `neovim` strategy opens the terminal tag right to the original tab.
				vim.g["test#neovim#term_position"] = "tab"
				vim.g["test#strategy"] = "neovim"
				if vim.fn.executable("richgo") then
					vim.g["test#go#runner"] = "richgo"
				end
			end,
		},
		{
			"nvim-neotest/neotest",
			dependencies = {
				"nvim-lua/plenary.nvim",
				"nvim-treesitter/nvim-treesitter",
				"nvim-neotest/neotest-go",
				"nvim-neotest/neotest-plenary",
				"rouge8/neotest-rust",
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
				require("neotest").setup({
					adapters = {
						require("neotest-go"),
						require("neotest-plenary"), -- the name of test file must be *_spec.lua
						require("neotest-rust"),
						-- For reference
						-- require("neotest-vim-test")({
						--   ignore_file_types = { "python", "vim", "lua" },
						-- }),
					},
					floating = {
						max_width = 0.8,
						-- For reference
						-- option = {
						--   -- wrap is false by default but long lines are wrapped
						--   wrap = true,
						-- },
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
						t = { 'lua require("neotest").run.run()', { desc = "Test nearest" } },
						T = { 'lua require("neotest").run.run(vim.fn.expand("%"))', { desc = "Test file" } },
						s = { 'lua require("neotest").run.stop()', { desc = "Stop test" } },
						o = { 'lua require("neotest").output.open({ quiet = false })', { desc = "Open test output" } },
						O = {
							'lua require("neotest").output.open({ enter = true, quiet = false })',
							{ desc = "Open test output and focus the window" },
						},
						p = { 'lua require("neotest").output_panel.toggle()', { desc = "Toggle output panel" } },
						m = { 'lua require("neotest").summary.toggle()', { desc = "Toggle summary" } },
					}
				)
				vim.keymap.set(
					"n",
					"[n",
					'<cmd>lua require("neotest").jump.prev({})<CR>',
					{ desc = "Jump to previous test" }
				)
				vim.keymap.set(
					"n",
					"]n",
					'<cmd>lua require("neotest").jump.next({})<CR>',
					{ desc = "Jump to next test" }
				)
			end,
		},
		{
			"akinsho/toggleterm.nvim",
			version = "*",
			config = function()
				require("toggleterm").setup({
					open_mapping = [[<C-\>]],
					on_create = function()
						vim.opt_local.signcolumn = "no"
					end,
					on_open = function()
						vim.cmd([[
								startinsert
								]])
					end,
					direction = "tab",
					shell = "fish",
				})
				vim.keymap.set("n", "<Leader>g", function()
					require("toggleterm.terminal").Terminal
						:new({
							cmd = "lazygit",
							direction = "float",
							float_opts = {
								width = math.floor(vim.o.columns * 0.95),
								height = math.floor(vim.o.lines * 0.90),
							},
						})
						:toggle()
				end, { desc = "lazygit" })
			end,
		},
		"mfussenegger/nvim-dap",
		{
			"rcarriga/nvim-dap-ui",
			dependencies = {
				"mfussenegger/nvim-dap",
			},
		},
		"tyru/open-browser.vim",

		-- Language specific
		-- fish
		{
			"dag/vim-fish",
			ft = "fish",
		},
		-- go
		{
			"ray-x/go.nvim",
			ft = { "go", "gomod", "gosum" },
			dependencies = { "ray-x/guihua.lua", build = "cd lua/fzy && make" },
			config = function()
				require("go").setup({
					test_runner = "richgo",
					run_in_floaterm = true,
					textobjects = false,
				})
				local go_format_augroud_id = vim.api.nvim_create_augroup("go_format", {})
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = go_format_augroud_id,
					pattern = "*.go",
					callback = function()
						require("go.format").goimport()
					end,
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
			cond = function()
				return vim.fn.executable("composer") == 0
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
			ft = "rust",
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
		"weirongxu/plantuml-previewer.vim",
		{
			"AckslD/nvim-FeMaco.lua",
			config = function()
				require("femaco").setup()
			end,
		},
	}, {
		performance = {
			rtp = {
				paths = opts.additional_rtp,
			},
		},
	})
end

return M
