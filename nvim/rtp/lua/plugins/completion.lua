return {
	{
		"hrsh7th/nvim-cmp",
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
						-- symbol_map = { Copilot = " " },
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
				}, {
					{ name = "nvim_lsp" },
				}, {
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
					-- enabled = false, -- disable this if copilot-cmp is enabled
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
						vim.api.nvim_echo({ msg, "WarningMsg" })
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
				strategies = {
					chat = {
						adapter = "copilot",
						keymaps = {
							send = {
								modes = { n = "<C-s>", i = "<C-j>" },
							},
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
				vim.g.chief_key .. "a",
				vim.g.chief_key,
				{
					a = { "CodeCompanion", { desc = "Open inline assistant" } },
					c = { "CodeCompanionChat Toggle", { desc = "Toggle chat buffer" } },
					m = { "CodeCompanionCmd", { desc = "Generate a vim command" } },
					p = { "CodeCompanionActions", { desc = "Open Action Palette" } },
				}
			)
		end,
		cmd = { "CodeCompanion", "CodeCompanionChat", "CodeCompanionCmd", "CodeCompanionActions" },
		keys = {
			{
				vim.g.chief_key .. "a",
				function()
					require("which-key").show({ keys = vim.g.chief_key .. "a" })
				end,
				mode = { "n" },
				desc = "CodeCompanion",
			},
		},
	},
}
