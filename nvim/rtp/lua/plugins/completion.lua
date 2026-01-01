local avante_keymap_prefix = vim.g.chief_key .. "a"
local snippets_path
for _, rtp in ipairs(vim.opt.runtimepath:get()) do
	local candidate = rtp .. "/snippets"
	if vim.fn.isdirectory(candidate) == 1 then
		snippets_path = candidate
		break
	end
end

return {
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets" },
		version = "1.*",
		---@module 'blink.cmp'
		---@type blink.cmp.Config
		opts = {
			-- See :h blink-cmp-config-keymap for defining your own keymap
			keymap = {
				preset = "none",
				["<Tab>"] = {
					"show_and_insert",
					"select_next",
				},
				["<C-g>"] = {
					"cancel",
					"fallback",
				},
				["<C-n>"] = {
					"select_next",
					"fallback",
				},
				["<C-p>"] = {
					"select_prev",
					"fallback",
				},
				["<C-o>"] = {
					"select_and_accept",
					"fallback",
				},
				["<C-s>"] = { "snippet_forward", "fallback" },
				["<M-s>"] = { "snippet_backward", "fallback" },
				["<M-k>"] = { "scroll_documentation_up", "fallback" },
				["<M-j>"] = { "scroll_documentation_down", "fallback" },
				["<M-K>"] = { "scroll_signature_up", "fallback" },
				["<M-J>"] = { "scroll_signature_down", "fallback" },
				["<C-x><C-h>"] = { "show_signature", "hide_signature", "fallback" },
			},

			appearance = {
				-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
				-- Adjusts spacing to ensure icons are aligned
				nerd_font_variant = "mono",
			},

			-- Whether to show the documentation popup automatically when manually triggered
			completion = {
				menu = { border = "rounded" },
				documentation = {
					auto_show = true,
					window = { border = "rounded" },
				},
				ghost_text = { enabled = false },
				trigger = {
					show_on_keyword = false,
					show_on_trigger_character = false,
				},
			},

			signature = { window = { border = "rounded" } },

			-- Default list of enabled providers defined so that you can extend it
			-- elsewhere in your config, without redefining it, due to `opts_extend`
			sources = {
				default = { "lsp", "path", "snippets", "buffer" },
				providers = { snippets = { opts = { search_paths = { snippets_path } } } },
			},

			-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
			-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
			-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
			--
			-- See the fuzzy documentation for more information
			fuzzy = { implementation = "prefer_rust_with_warning" },
		},
		opts_extend = { "sources.default" },
	},
	{
		"hrsh7th/nvim-cmp",
		enabled = false,
		dependencies = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "hrsh7th/cmp-cmdline" },
			{ "onsails/lspkind.nvim" },
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
				preselect = cmp.PreselectMode.Item,
				formatting = {
					format = require("lspkind").cmp_format({
						maxwidth = {
							-- This seems not working
							menu = function()
								return math.floor(0.60 * vim.o.columns)
							end, -- leading text (labelDetails)
						},
						-- Show labelDetails in menu. Not sure what difference it makes.
						show_labelDetails = true,
						symbol_map = { Copilot = " " },
					}),
				},
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
				completion = {
					autocomplete = false,
					-- This option must be set here as well in order for `preselect = cmp.PreselectMode.Item` to work.
					-- The `longest` option is not supported by nvim-cmp. https://github.com/hrsh7th/nvim-cmp/issues/530
					completeopt = vim.iter(vim.opt.completeopt:get()):join(","),
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
					["<C-g>"] = cmp.mapping(cmp_visible_or_fallback(cmp.abort), { "i", "c" }),
					-- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
					["<C-y>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
					["<C-o>"] = cmp.mapping(cmp.mapping.confirm({ select = false }), { "i", "c" }),
					["<C-a>"] = cmp.mapping(close_and_fallback, { "i", "c" }),
					["<C-e>"] = cmp.mapping(close_and_fallback, { "i", "c" }),
					["<C-k>"] = cmp.mapping(cmp_visible_or_fallback(cmp.abort), { "i", "c" }),
					["<C-x><C-n>"] = cmp.mapping(function()
						cmp.complete({ config = { sources = { { name = "buffer" } } } })
					end, { "i", "c" }),
				},
				-- cmp.config.sources sets the order of completion. See :help cmp-config.sources[n].group_index
				sources = cmp.config.sources({
					-- { name = "copilot" },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
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
			cmp.setup.cmdline(":", { sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline" } }) })

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
		event = { "InsertEnter", "CmdlineEnter" },
	},
	{
		"jackMort/ChatGPT.nvim",
		enabled = false,
		-- enabled = function()
		-- 	return vim.env.OPENAI_API_KEY ~= nil
		-- end,
		dependencies = {
			"MunifTanjim/nui.nvim",
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			-- These must be done before setup()
			-- NOTE: If you overwrite URLs, the below environment variables are not used.
			-- Set dummy values to suppress the warning message.
			-- vim.env.OPENAI_API_BASE = "xxx"
			-- vim.env.OPENAI_API_AZURE_ENGINE = "xxx"
			-- NOTE: Do not forget to set the below environment variable if the authorization header key needs to be `api-key`
			-- vim.env.OPENAI_API_TYPE = "azure"
			local key_prefix = "<C-g>"
			local key_session_prefix = "<C-s>"
			require("chatgpt").setup({
				edit_with_instructions = {
					keymaps = {
						accept = key_prefix .. "<C-y>",
						toggle_diff = key_prefix .. "<C-d>",
						toggle_settings = key_prefix .. "<C-o>",
						toggle_help = "<M-?>",
						cycle_windows = key_prefix .. "<C-w>",
						use_output_as_input = key_prefix .. "<C-i>",
					},
				},
				chat = {
					keymaps = {
						yank_last = key_prefix .. "<C-y>",
						yank_last_code = key_prefix .. "<C-k>",
						scroll_up = "<M-k>",
						scroll_down = "<M-j>",
						cycle_windows = key_prefix .. "<C-w>",
						cycle_modes = key_prefix .. "<C-f>",
						next_message = key_prefix .. "<C-j>",
						prev_message = key_prefix .. "<C-k>",
						draft_message = key_prefix .. "<C-r>",
						edit_message = key_prefix .. "<C-e>",
						delete_message = key_prefix .. "<C-d>",
						new_session = key_prefix .. key_session_prefix .. "<C-n>",
						select_session = key_prefix .. key_session_prefix .. "<CR>",
						rename_session = key_prefix .. key_session_prefix .. "<C-r>",
						delete_session = key_prefix .. key_session_prefix .. "<C-d>",
						toggle_sessions = key_prefix .. key_session_prefix .. "<C-p>",
						toggle_settings = key_prefix .. "<C-o>",
						toggle_help = "<M-?>",
						toggle_message_role = key_prefix .. "<C-r>" .. "<C-m>",
						toggle_system_role_open = key_prefix .. "<C-r>" .. "<C-s>",
						stop_generating = key_prefix .. "<C-x>",
					},
				},
				popup_input = {
					submit = key_prefix .. key_prefix,
				},
			})
			-- These are to be done after setup()
			-- NOTE: Overwrite URLs if the URL scheme is different from open AI
			-- require("chatgpt.api").COMPLETIONS_URL = "<URL>"
			-- require("chatgpt.api").CHAT_COMPLETIONS_URL = "<URL>"
			-- require("chatgpt.api").EDITS_URL = "<URL>"
		end,
		event = "VeryLazy",
	},
	{
		"zbirenbaum/copilot.lua",
		enabled = function()
			return vim.fn.executable("node") ~= 0
		end,
		dependencies = {
			{ "anuvyklack/keymap-amend.nvim" },
		},
		config = function()
			require("copilot").setup({
				panel = {
					-- enabled = false, -- disable this if copilot-cmp is enabled
					auto_refresh = true,
					layout = {
						position = "right", -- bottom | top | left | right | horizontal | vertical
						ratio = 0.4,
					},
				},
				suggestion = {
					-- enabled = false, -- copilot-cmp does not work if this is enabled
					auto_trigger = true,
					debounce = 120,
					-- some keymaps are set manually below setup()
					keymap = {
						accept = false,
						accept_word = false,
						accept_line = false,
						next = "<M-n>",
						prev = "<M-p>",
						dismiss = false,
					},
				},
				filetypes = {
					yaml = true,
				},
				logger = {
					-- file_log_level = vim.log.levels.DEBUG,
				},
				should_attach = function(bufnr, bufname)
					-- NOTE: DO NOT use vim.notify or anything that creates new buffer here.
					-- It might end up infinate call to this function as this function runs every time a buffer is created.
					-- (Infinate notifications in case of vim.notify)

					-- original function begins --
					if not vim.bo.buflisted then
						require("copilot.logger").debug(
							string.format("not attaching, buffer '%s (%s)' is not 'buflisted'", bufname, bufnr)
						)
						return false
					end

					if vim.bo.buftype ~= "" then
						require("copilot.logger").debug(
							string.format(
								"not attaching, 'buftype' of buffer '%s (%s)' is %s",
								bufname,
								bufnr,
								vim.bo.buftype
							)
						)
						return false
					end
					-- original function ends --

					-- Do not attach on bufer without filetype
					if vim.api.nvim_get_option_value("filetype", { buf = bufnr }) == "" then
						require("copilot.logger").debug(
							string.format("not attaching, no filetype is set to buffer '%s (%s)'", bufname, bufnr)
						)
						return false
					end

					-- Do not attach if the buffer name is not absolute path
					-- because the other checks expects the buffer path to be absolute path
					if bufname ~= "" and not vim.startswith(bufname, "/") then
						local msg =
							string.format("not attaching, buffer name is not absolute path: %s (%s)", bufname, bufnr)
						vim.api.nvim_echo({ msg, "WarningMsg" }, true, {})
						require("copilot.logger").debug(msg)
						return false
					end

					-- Do not attach on hidden files or any files under hidden directory
					if string.match(bufname, "/%.") then
						require("copilot.logger").debug(
							string.format(
								"not attaching, buffer '%s (%s)' is either hidden file or file inside hidden directory",
								bufname,
								bufnr
							)
						)
						return false
					end

					-- Other files (partial match) to ignore
					local ignore_patterns = {}
					for _, ignore_pattern in ipairs(ignore_patterns) do
						if string.match(bufname, ignore_pattern) then
							require("copilot.logger").debug(
								string.format(
									"not attaching, buffer '%s (%s)' matches the hardcoded ignore pattern '%s'",
									bufname,
									bufnr,
									ignore_pattern
								)
							)
							return false
						end
					end

					-- Do not attach if any of the parent directories contains .copilotignore
					-- if vim.fs.root(bufname, { ".copilotignore" }) then
					-- 	return false
					-- end

					-- Do not attach if the buffer matches any of the files in .copilotignore.
					local copilotignore = vim.fs.find(".copilotignore", {
						path = vim.fs.dirname(bufname),
						upward = true,
						type = "file",
					})
					if not vim.tbl_isempty(copilotignore) then
						copilotignore = copilotignore[1]
						local copilotignore_file, err = io.open(copilotignore, "r")
						if copilotignore_file == nil then
							error(string.format("failed to open .copilotignore: %s", err))
						end

						local attach = true
						local copilotignore_dir = vim.fs.dirname(copilotignore)
						for line in copilotignore_file:lines() do
							local glob_files = vim.split(vim.fn.globpath(copilotignore_dir, line), "\n")
							if vim.list_contains(glob_files, bufname) then
								attach = false
								require("copilot.logger").debug(
									string.format(
										"not attaching, buffer '%s (%s)' matches the pattern in .copilotignore '%s'",
										bufname,
										bufnr,
										line
									)
								)
								break
							end
						end
						copilotignore_file:close()
						if not attach then
							return false
						end
					end

					return true
				end,
			})
			local keymap_amend = require("keymap-amend")
			local copilot_suggestion = require("copilot.suggestion")
			keymap_amend("i", "<C-o>", function(original)
				if copilot_suggestion.is_visible() then
					copilot_suggestion.accept()
				else
					original()
				end
			end, { desc = "Copilot accept or default" })
			keymap_amend("i", "<M-f>", function(original)
				if copilot_suggestion.is_visible() then
					copilot_suggestion.accept_word()
				else
					original()
				end
			end, { desc = "Copilot accept word or next word" })
			keymap_amend("i", "<C-e>", function(original)
				if copilot_suggestion.is_visible() then
					copilot_suggestion.accept_line()
				else
					original()
				end
			end, { desc = "Copilot accept line or end of line" })
			keymap_amend("i", "<C-q>", function(original)
				if copilot_suggestion.is_visible() then
					copilot_suggestion.dismiss()
				else
					original()
				end
			end, { desc = "Copilot dismiss or default" })
		end,
		cmd = "Copilot",
		-- The trigger event was originally "InsertEnter" but if telescope is opened before the first insert,
		-- `original` keymap in keymap-amend will be the one defined in telescope, so it will not work as expected.
		event = "VeryLazy",
	},
	{
		"zbirenbaum/copilot-cmp",
		enabled = false,
		dependencies = {
			"zbirenbaum/copilot.lua",
		},
		config = function()
			require("copilot_cmp").setup()
		end,
	},
	{
		"olimorris/codecompanion.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-treesitter/nvim-treesitter",
			"MeanderingProgrammer/render-markdown.nvim",
			"echasnovski/mini.diff",
		},
		config = function()
			require("codecompanion").setup({
				interactions = {
					chat = {
						adapter = "copilot",
						keymaps = {
							close = {
								modes = { n = "q", i = "<S-F14>" },
							},
						},
						opts = {
							---Decorate the user message before it's sent to the LLM
							---@param message string
							---@param adapter CodeCompanion.Adapter
							---@param context table
							---@return string
							prompt_decorator = function(message, adapter, context)
								if adapter.name == "copilot" then
									-- Wrapping with `<prompt></prompt>` is how Copilot in VS Code does, so mimic it here
									return string.format([[<prompt>%s</prompt>]], message)
								end

								return message
							end,
						},
					},
					inline = {
						adapter = "copilot",
					},
				},
			})
			require("keymap.which-key-helper").register_with_editable(
				"CodeCompanion",
				vim.g.chief_key .. "c",
				vim.g.chief_key,
				{
					c = {
						rhs = "CodeCompanionChat Toggle",
						mode = { "n", "x" },
						opts = { desc = "Toggle chat buffer" },
					},
					i = { rhs = "CodeCompanion", opts = { desc = "Open inline assistant" } },
					m = { rhs = "CodeCompanionCmd", mode = { "n", "x" }, opts = { desc = "Generate a vim command" } },
					p = { rhs = "CodeCompanionActions", mode = { "n", "x" }, opts = { desc = "Open Action Palette" } },
				}
			)
		end,
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
		keys = {
			{ vim.g.chief_key .. "a", mode = { "n", "x" }, desc = "CodeCompanion" },
			{ vim.g.chief_key .. "ai", ":CodeCompanion<CR>", mode = { "x" }, desc = "Open inline assistant" },
		},
	},
	{
		"yetone/avante.nvim",
		enabled = function()
			local disabled = os.getenv("AVANTE_DISABLE")
			return disabled and disabled:lower() == "true"
		end,
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			--- The below dependencies are optional,
			-- "nvim-mini/mini.pick", -- for file_selector provider mini.pick
			"nvim-telescope/telescope.nvim", -- for file_selector provider telescope
			"hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
			"ibhagwan/fzf-lua", -- for file_selector provider fzf
			"stevearc/dressing.nvim", -- for input provider dressing
			"folke/snacks.nvim", -- for input provider snacks
			"nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
			"zbirenbaum/copilot.lua", -- for providers='copilot'
			-- {
			-- 	-- support for image pasting
			-- 	"HakonHarnes/img-clip.nvim",
			-- 	event = "VeryLazy",
			-- 	opts = {
			-- 		-- recommended settings
			-- 		default = {
			-- 			embed_image_as_base64 = false,
			-- 			prompt_for_file_name = false,
			-- 			drag_and_drop = {
			-- 				insert_mode = true,
			-- 			},
			-- 			-- required for Windows users
			-- 			use_absolute_path = true,
			-- 		},
			-- 	},
			-- },
			{
				-- Make sure to set this up properly if you have lazy=true
				"MeanderingProgrammer/render-markdown.nvim",
				opts = {
					file_types = { "markdown", "Avante" },
				},
				ft = { "markdown", "Avante" },
			},
		},
		-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
		-- ⚠️ must add this setting! ! !
		build = vim.fn.has("win32") ~= 0
				and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
			or "make",
		event = "VeryLazy",
		version = false, -- Never set this value to "*"! Never!
		config = function()
			local provider = os.getenv("AVANTE_PROVIDER") or "copilot"
			local ollama_model = os.getenv("AVANTE_OLLAMA_MODEL") or "gpt-oss:20b"
			---@module 'avante'
			---@type avante.Config
			local config = {
				provider = provider,
				behaviour = {
					auto_approve_tool_permissions = false,
				},
				mappings = {
					ask = avante_keymap_prefix .. "a",
					new_ask = avante_keymap_prefix .. "n",
					zen_mode = avante_keymap_prefix .. "z",
					edit = avante_keymap_prefix .. "e",
					refresh = avante_keymap_prefix .. "r",
					focus = avante_keymap_prefix .. "f",
					stop = avante_keymap_prefix .. "S",
					toggle = {
						default = avante_keymap_prefix .. "t",
						debug = avante_keymap_prefix .. "d",
						selection = avante_keymap_prefix .. "C",
						suggestion = avante_keymap_prefix .. "s",
						repomap = avante_keymap_prefix .. "R",
					},
					sidebar = {
						toggle_code_window = "gq",
						close_from_input = { normal = "q" },
						toggle_code_window_from_input = { normal = "gq" },
					},
					files = {
						add_current = avante_keymap_prefix .. "c", -- Add current buffer to selected files
						add_all_buffers = avante_keymap_prefix .. "B", -- Add all buffer files to selected files
					},
					select_model = avante_keymap_prefix .. "?", -- Select model command
					select_history = avante_keymap_prefix .. "h", -- Select history command
				},
				selection = {
					hint_display = "none",
				},
				windows = {
					spinner = {
						generating = { "-", "/", "|", "\\" },
					},
					input = {
						height = 12,
					},
					edit = {
						border = "rounded",
						start_insert = false,
					},
					ask = {
						border = "rounded",
						start_insert = false,
					},
				},
			}
			if provider == "ollama" then
				config.providers = {
					ollama = {
						model = ollama_model,
						is_env_set = require("avante.providers.ollama").check_endpoint_alive,
					},
				}
			end
			require("avante").setup(config)
		end,
	},
}
