return {
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
			require("chatgpt").setup({
				popup_input = {
					submit = "<F10>",
				},
			})
			-- NOTE: Overwrite URLs if the URL scheme is different from open AI
			-- require("chatgpt.api").COMPLETIONS_URL = "<URL>"
			-- require("chatgpt.api").CHAT_COMPLETIONS_URL = "<URL>"
			-- require("chatgpt.api").EDITS_URL = "<URL>"
			-- In such case, the below environment variables are not used but may be set to suppress the warning message:
			-- vim.env.OPENAI_API_BASE = "xxx"
			-- vim.env.OPENAI_API_AZURE_ENGINE = "xxx"
			-- NOTE: Do not forget to set the below environment variable if the authorization header key needs to be `api-key`
			-- vim.env.OPENAI_API_TYPE = "azure"
		end,
		event = "VeryLazy",
	},
}
