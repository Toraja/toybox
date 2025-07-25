return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-telescope/telescope-ghq.nvim" },
			{ "LinArcX/telescope-scriptnames.nvim" },
			{ "brookhong/telescope-pathogen.nvim" },
			{ "fbuchlak/telescope-directory.nvim" },
			{ "tsakirist/telescope-lazy.nvim" },
			{ "benfowler/telescope-luasnip.nvim" },
			{ "TC72/telescope-tele-tabby.nvim" },
			{ "axkirillov/easypick.nvim" },
			{ "nvim-telescope/telescope-live-grep-args.nvim", version = "*" },
		},
		config = function()
			-- Add line number to preview
			vim.api.nvim_create_autocmd({ "User" }, {
				group = vim.api.nvim_create_augroup("my_telescope", {}),
				pattern = "TelescopePreviewerLoaded",
				callback = function()
					vim.opt_local.number = true
				end,
			})

			local telescope = require("telescope")
			local action = require("telescope.actions")
			local action_set = require("telescope.actions.set")
			local action_state = require("telescope.actions.state")
			local action_layout = require("telescope.actions.layout")
			local builtin = require("telescope.builtin")
			local pickers = require("telescope.pickers")
			local finders = require("telescope.finders")
			local conf = require("telescope.config").values
			local function bottom_pane_borderchars()
				return {
					prompt = { "─", "│", " ", "│", "╭", "╮", "", " " },
					preview = { "─", "│", "─", "│", "╭", "│", "╯", "─" },
					results = { " ", " ", "─", "│", " ", " ", "─", "╰" },
				}
			end
			local easypick = require("easypick")
			local lga_actions = require("telescope-live-grep-args.actions")
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
							["<M-l>"] = function(bufnr)
								action_set.scroll_horizontal_previewer(bufnr, 1)
							end,
							["<M-h>"] = function(bufnr)
								action_set.scroll_horizontal_previewer(bufnr, 0)
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
							["<C-f>"] = { "<Right>", type = "command" },
							["<C-k>"] = false,
							["<M-j>"] = function(bufnr)
								action_set.scroll_previewer(bufnr, 0.5)
							end,
							["<M-k>"] = function(bufnr)
								action_set.scroll_previewer(bufnr, -0.5)
							end,
							["<M-l>"] = function(bufnr)
								action_set.scroll_horizontal_previewer(bufnr, 1)
							end,
							["<M-h>"] = function(bufnr)
								action_set.scroll_horizontal_previewer(bufnr, 0)
							end,
							["<C-M-n>"] = action.cycle_history_next,
							["<C-M-p>"] = action.cycle_history_prev,
							["<M-?>"] = require("telescope.actions.generate").which_key({
								max_height = 0.7, -- increase potential maximum height
							}),
							["<M-m>"] = function(bufnr)
								local entry = action_state.get_selected_entry()
								local file_dir = vim.fs.dirname(entry[1])
								local telescope_cwd = entry.cwd
								action.close(bufnr)
								vim.cmd({
									cmd = "Neotree",
									args = {
										"position=float",
										string.format("dir=%s/%s", telescope_cwd, file_dir),
									},
								})
							end,
						},
					},
				},
				pickers = {
					-- Default configuration for builtin pickers goes here:
					find_files = {
						find_command = function()
							if vim.fn.executable("fd") == 1 then
								return { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--color", "never" }
							elseif vim.fn.executable("fdfind") == 1 then
								return { "fdfind", "--type", "f", "--hidden", "--exclude", ".git", "--color", "never" }
							end
							return { "find", "--type", "f", "-path", "./.git", "-prune", "-o", "-print" }
						end,
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
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
					pathogen = {
						attach_mappings = function(map, actions)
							map("i", "<C-o>", actions.proceed_with_parent_dir)
							map("i", "<M-o>", actions.revert_back_last_dir)
							map("i", "<M-e>", actions.change_working_directory)
							map("i", "<C-s>", actions.grep_in_result)
							map("i", "<M-s>", actions.invert_grep_in_result)
						end,
						-- remove below if you want to enable it
						use_last_search_for_live_grep = false,
						prompt_prefix_length = 100,
					},
					directory = {
						finder_cmd = function(opts)
							local cmd = { "fd", "--type", "d", "--hidden", "--exclude", ".git", "--color", "never" }
							if opts.base_dir then
								vim.list_extend(cmd, { "--base-directory", vim.fn.expand(opts.base_dir) })
							end
							return cmd
						end,
					},
					live_grep_args = {
						auto_quoting = true, -- enable/disable auto-quoting
						mappings = {
							i = {
								['<M-">'] = lga_actions.quote_prompt(),
								["<M-g>"] = lga_actions.quote_prompt({ postfix = " --iglob " }),
							},
						},
					},
				},
			})
			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")
			telescope.load_extension("ghq")
			telescope.load_extension("scriptnames")
			telescope.load_extension("pathogen")
			telescope.load_extension("directory")
			telescope.load_extension("lazy")
			telescope.load_extension("luasnip")
			telescope.load_extension("tele_tabby")
			telescope.load_extension("live_grep_args")

			builtin.live_grep = require("telescope").extensions.live_grep_args.live_grep_args

			local function easypick_nvim_func(f)
				return function(prompt_bufnr, _)
					action.select_default:replace(function()
						action.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						f(selection[1])
					end)
					return true
				end
			end

			local function get_abs_path_of_entry()
				local selection = action_state.get_selected_entry()
				return require("git").root_path() .. "/" .. selection[1]
			end

			---@param opts table
			---@param attach_mappings fun(prompt_bufnr: number): boolean
			local function pick_dir(opts, attach_mappings)
				opts = opts or {}

				local cwd = opts.cwd or vim.uv.cwd()
				vim.cmd("lcd " .. cwd) -- preview is not displayed without this
				pickers
					.new(opts, {
						prompt_title = "Pick Directory",
						finder = finders.new_oneshot_job({
							"fd",
							"--type",
							"d",
							"--hidden",
							"--exclude",
							".git",
							"--color",
							"never",
						}, { cwd = cwd }),
						sorter = conf.generic_sorter(opts),
						previewer = conf.file_previewer(opts),
						attach_mappings = attach_mappings,
					})
					:find()
			end

			easypick.setup({
				pickers = {
					{
						name = "makefile",
						-- command = "PJ_ROOT_DIR=$(git rev-parse --show-toplevel) && find $PJ_ROOT_DIR -type f -name Makefile -exec realpath --relative-to $PJ_ROOT_DIR {} \\; | sort",
						command = "fd --type f --color never --base-directory $(git rev-parse --show-toplevel) Makefile | sort",
						opts = require("telescope.themes").get_dropdown({
							layout_config = {
								height = function(_, _, max_lines)
									return math.min(max_lines, 30)
								end,
							},
						}),
						action = easypick_nvim_func(function(selected)
							local path = vim.fs.dirname(require("git").root_path() .. "/" .. selected)
							local make_recipes = require("greyjoy._extensions.makefile").exports.parse({
								filename = "Makefile",
								filepath = path,
							})
							require("greyjoy").menu(make_recipes)
						end),
					},
					{
						name = "subroot",
						command = "fd --type d --color never --base-directory $(git rev-parse --show-toplevel) --exact-depth 1 | sort",
						opts = require("telescope.themes").get_dropdown({
							layout_config = {
								height = function(_, _, max_lines)
									return math.min(max_lines, 30)
								end,
							},
						}),
						action = function(prompt_bufnr, map)
							action.select_default:replace(function()
								action.close(prompt_bufnr)
								local path = get_abs_path_of_entry()
								vim.cmd("lcd" .. path)
							end)

							map({ "i" }, "<C-v>", function()
								action.close(prompt_bufnr)
								local path = get_abs_path_of_entry()
								vim.cmd("vnew " .. path)
							end)
							map({ "i" }, "<C-t>", function()
								action.close(prompt_bufnr)
								local path = get_abs_path_of_entry()
								vim.cmd("tabnew " .. path)
							end)
							map({ "i" }, "<C-\\>", function()
								action.close(prompt_bufnr)
								-- local path = get_abs_path_of_entry()
								-- TODO: open terminal in tab, or float term using toggleterm
								print("C-\\")
							end)
							map({ "i" }, "<C-f>", function()
								action.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()[1]
								local path = require("git").root_path() .. "/" .. selection
								builtin.find_files({
									prompt_title = string.format("Find Files (%s)", selection),
									cwd = path,
								})
							end)
							map({ "i" }, "<M-f>", function()
								action.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()[1]
								local path = require("git").root_path() .. "/" .. selection
								pick_dir(
									{ cwd = path, prompt_title = "Pick Directory (Find Files)" },
									---@diagnostic disable-next-line: redefined-local
									function(prompt_bufnr)
										action.select_default:replace(function()
											action.close(prompt_bufnr)
											---@diagnostic disable-next-line: redefined-local
											local selection = action_state.get_selected_entry()[1]
											require("pathogen").find_files({
												cwd = path,
												prompt_title = string.format("Find Files (%s): ", selection),
												search_dirs = { path .. "/" .. selection },
											})
										end)
										return true
									end
								)
							end)
							map({ "i" }, "<C-g>", function()
								action.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()[1]
								local path = require("git").root_path() .. "/" .. selection
								builtin.live_grep({
									prompt_title = string.format("Live Grep (%s)", selection),
									cwd = path,
								})
							end)
							map({ "i" }, "<M-g>", function()
								action.close(prompt_bufnr)
								local selection = action_state.get_selected_entry()[1]
								local path = require("git").root_path() .. "/" .. selection
								pick_dir(
									{ cwd = path, prompt_title = "Pick Directory (Live Grep)" },
									---@diagnostic disable-next-line: redefined-local
									function(prompt_bufnr)
										action.select_default:replace(function()
											action.close(prompt_bufnr)
											---@diagnostic disable-next-line: redefined-local
											local selection = action_state.get_selected_entry()[1]
											require("pathogen").live_grep({
												cwd = path,
												prompt_title = string.format("Live Grep (%s): ", selection),
												search_dirs = { path .. "/" .. selection },
											})
										end)
										return true
									end
								)
							end)

							return true
						end,
					},
				},
			})

			local tele_tabby_opts = require("telescope.themes").get_dropdown()
			require("keymap.which-key-helper").register_with_editable(
				"Telescope",
				vim.g.chief_key .. "f",
				vim.g.chief_key,
				{
					a = { rhs = "Easypick subroot", opts = { desc = "Telescope in subroot" } },
					b = { rhs = "Telescope buffers", opts = { desc = "Buffers" } },
					c = { rhs = "Telescope git_bcommits", opts = { desc = "Git buffer commits" } },
					C = { rhs = "Telescope git_commits", opts = { desc = "Git commits" } },
					d = { rhs = "Telescope diagnostics", opts = { desc = "Diagnostics" } },
					e = { rhs = "Telescope pathogen pathogen", opts = { desc = "File browser" } },
					f = { rhs = "Telescope pathogen find_files", opts = { desc = "Files" } },
					F = {
						rhs = "Telescope directory find_files prompt_title=Directory+Find",
						opts = { desc = "Directory + Find" },
					},
					g = { rhs = "Telescope pathogen live_grep", opts = { desc = "Grep" } },
					G = {
						rhs = "Telescope directory live_grep prompt_title=Directory+Grep ",
						opts = { desc = "Directory + Grep" },
					},
					h = { rhs = "Telescope help_tags", opts = { desc = "Help tags" } },
					H = { rhs = "Telescope highlights", opts = { desc = "Highlights" } },
					k = { rhs = "Telescope keymaps", opts = { desc = "Keymaps" } },
					l = { rhs = "Telescope current_buffer_fuzzy_find", opts = { desc = "Buffer lines" } },
					m = { rhs = "Easypick makefile", opts = { desc = "Makefiles" } },
					M = { rhs = "Telescope marks", opts = { desc = "Marks" } },
					n = { rhs = "Telescope notify notify", opts = { desc = "Notifications" } },
					o = {
						rhs = function()
							---@diagnostic disable-next-line: missing-parameter
							if vim.lsp.buf_is_attached(0) then
								require("telescope.builtin").lsp_document_symbols({ symbol_width = 40 })
							else
								require("telescope.builtin").treesitter()
							end
						end,
						opts = { desc = "Document symbols" },
					},
					O = { rhs = "Telescope oldfiles", opts = { desc = "Oldfiles" } },
					p = { rhs = "Telescope lazy lazy", opts = { desc = "Lazy" } },
					P = { rhs = "Telescope spell_suggest", opts = { desc = "Spell suggest" } },
					q = { rhs = "Telescope ghq list layout_config={'preview_width':0.5}", opts = { desc = "Ghq list" } },
					s = { rhs = "Telescope luasnip luasnip", opts = { desc = "Snippets" } },
					S = { rhs = "Telescope scriptnames scriptnames", opts = { desc = "Scriptnames" } },
					t = {
						rhs = function()
							local tablist = vim.api.nvim_list_tabpages()
							tele_tabby_opts.layout_config.height = vim.tbl_count(tablist) + 4 -- 4 means search window and borders
							tele_tabby_opts.layout_config.width = 150
							require("telescope").extensions.tele_tabby.list(tele_tabby_opts)
						end,
						opts = { desc = "Tab" },
					},
					T = { rhs = "TodoTelescope", opts = { desc = "Todo comments" } },
					v = { rhs = "Telescope git_status", opts = { desc = "Git status" } },
					V = { rhs = "Telescope git_files", opts = { desc = "Git files" } },
					y = { rhs = "Telescope yank_history yank_history", opts = { desc = "Yank history" } },
					[":"] = { rhs = "Telescope command_history", opts = { desc = "Command history" } },
					["/"] = { rhs = "Telescope search_history", opts = { desc = "Search history" } },
					["<Space>"] = { rhs = "Telescope resume", opts = { desc = "Resume previous picker" } },
				}
			)
		end,
		cmd = { "Telescope" },
		keys = {
			{
				vim.g.chief_key .. "f",
				function()
					require("which-key").show({ keys = vim.g.chief_key .. "f" })
				end,
				mode = { "n" },
				desc = "Telescope",
			},
		},
	},
}
