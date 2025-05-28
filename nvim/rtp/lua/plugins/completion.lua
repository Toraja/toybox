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
				preselect = cmp.PreselectMode.None,
				formatting = {
					format = require("lspkind").cmp_format({
						maxwidth = {
							menu = function()
								return math.floor(0.60 * vim.o.columns)
							end, -- leading text (labelDetails)
						},
						show_labelDetails = true, -- show labelDetails in menu. Disabled by default
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
				sources = cmp.config.sources({
					{ name = "copilot", group_index = 1 },
					{ name = "nvim_lsp", group_index = 2 },
					{ name = "luasnip", group_index = 3 },
					{ name = "buffer", group_index = 4 },
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
		enabled = function()
			return vim.env.OPENAI_API_KEY ~= nil
		end,
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
		config = function()
			require("copilot").setup({
				panel = {
					enabled = false, -- disabled for copilot-cmp
					auto_refresh = true,
					layout = {
						position = "right", -- bottom | top | left | right | horizontal | vertical
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = false, -- disabled for copilot-cmp
					auto_trigger = true,
					debounce = 120,
				},
				file_types = {
					yaml = true,
				},
				should_attach = function(_, bufname)
					-- original function begins --
					if not vim.bo.buflisted then
						require("copilot.logger").debug("not attaching, buffer is not 'buflisted'")
						return false
					end

					if vim.bo.buftype ~= "" then
						require("copilot.logger").debug("not attaching, buffer 'buftype' is " .. vim.bo.buftype)
						return false
					end
					-- original function ends --

					-- Do not attach on bufer without name and filetype
					if bufname == "" and vim.api.nvim_get_option_value("filetype", {}) == "" then
						return false
					end

					-- Do not attach if the buffer name is not absolute path
					-- because the other checks expects the buffer path to be absolute path
					if bufname == "" and not vim.startswith(bufname, "/") then
						vim.notify(
							"not attaching, buffer name is not absolute path: " .. bufname,
							vim.log.levels.WARN,
							{ title = "copilot.lua" }
						)
						return false
					end

					-- Do not attach on hidden files or any files under hidden directory
					if string.match(bufname, "/%.") then
						return false
					end

					-- Other files (partial match) to ignore
					local ignored_files = {}
					for _, ignored_file in ipairs(ignored_files) do
						if string.match(bufname, ignored_file) then
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
		end,
		cmd = "Copilot",
		event = "InsertEnter",
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = {
			"zbirenbaum/copilot.lua",
		},
		config = function()
			require("copilot_cmp").setup()
		end,
	},
}
