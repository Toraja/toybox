return {
	{
		"neovim/nvim-lspconfig",
		dependencies = { "saghen/blink.cmp" },
		config = function()
			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#abb2bf", reverse = true })
			-- vim.lsp.set_log_level("debug")

			local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
			function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
				opts = opts or {}
				opts.border = opts.border or "rounded"
				opts.max_width = opts.max_width or 100
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end

			local capabilities = {
				textDocument = {
					completion = {
						completionItem = {
							resolveSupport = {
								properties = {
									"documentation",
									"command",
									"detail",
									"additionalTextEdits",
								},
							},
						},
					},
				},
			}
			capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)
			local servers = {
				lua_ls = {
					on_init = function(client)
						local path = client.workspace_folders[1].name
						if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
							return
						end

						client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
							runtime = {
								-- Tell the language server which version of Lua you're using
								-- (most likely LuaJIT in the case of Neovim)
								version = "LuaJIT",
							},
							-- Make the server aware of Neovim runtime files
							format = {
								enable = true,
								-- Put format options here
								-- NOTE: the value should be STRING!!
								defaultConfig = {
									indent_style = "space",
									indent_size = "2",
								},
							},
							telemetry = {
								enable = false,
							},
							workspace = {
								checkThirdParty = false,
								-- library = {
								-- 	vim.env.VIMRUNTIME,
								-- Depending on the usage, you might want to add additional paths here.
								-- "${3rd}/luv/library"
								-- "${3rd}/busted/library",
								-- },
								-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
								library = vim.api.nvim_get_runtime_file("", true),
							},
							-- Do not send telemetry data containing a randomized but unique identifier
						})
					end,
					settings = {
						Lua = {
							diagnostics = {
								-- Get the language server to recognize the `vim` global
								-- Somehow it does not work if this setting is in `on_init`
								globals = { "vim" },
							},
						},
					},
				},
			}
			if vim.fn.executable("gopls") == 1 then
				servers.gopls = {}
			end
			if vim.fn.executable("helm_ls") == 1 then
				servers.helm_ls = {
					settings = {
						["helm-ls"] = { -- it must be `-` instead of `_`
							yamlls = {
								enabled = true,
								-- When `config` is specified, default config is all replaced rather than merged.
								-- So it is necessary to specify every fields you need.
								config = {
									validate = true,
									completion = true,
									hover = true,
									schemas = {
										kubernetes = "templates/**",
										["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1beta1.json"] = "templates/**",
									},
								},
							},
						},
					},
				}
			end
			if vim.fn.executable("vscode-json-language-server") == 1 then
				servers.jsonls = {}
			end
			if vim.fn.executable("phpactor") == 1 then
				servers.phpactor = {
					-- taken from https://phpactor.readthedocs.io/en/master/lsp/vim.html
					init_options = {
						["language_server_phpstan.enabled"] = false,
						["language_server_psalm.enabled"] = false,
					},
				}
			end
			if vim.fn.executable("pyright") == 1 then
				servers.pyright = {}
			end
			if vim.fn.executable("taplo") == 1 then
				servers.taplo = {}
			end
			for lsp, setting in pairs(servers) do
				vim.lsp.config(lsp, vim.tbl_extend("force", { capabilities = capabilities }, setting))
				vim.lsp.enable(lsp)
			end

			vim.keymap.set("i", "<C-x><C-h>", "<Cmd>lua vim.lsp.buf.signature_help()<CR>", { desc = "Signature help" })
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
				vim.g.vert_key .. "<C-]>",
				"<Cmd>vertical split | lua vim.lsp.buf.definition()<CR>",
				{ desc = "Definition [vert]" }
			)
			vim.keymap.set(
				"n",
				vim.g.vert_key .. "<C-g><C-]>",
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
				a = { rhs = "lua vim.lsp.buf.code_action()", opts = { desc = "Code action" } },
				c = { rhs = "lua vim.lsp.buf.incoming_calls()", opts = { desc = "Incoming calls" } },
				C = { rhs = "lua vim.lsp.buf.outgoing_calls()", opts = { desc = "Outgoing calls" } },
				d = { rhs = "lua vim.diagnostic.setloclist()", opts = { desc = "Diagnostic (buffer)" } },
				D = { rhs = "lua vim.diagnostic.setqflist()", opts = { desc = "Diagnostic (all)" } },
				f = { rhs = "lua vim.lsp.buf.format({ async = true })", opts = { desc = "Format" } },
				h = { rhs = "lua vim.lsp.buf.document_highlight()", opts = { desc = "Highlight symbol" } },
				H = { rhs = "lua vim.lsp.buf.clear_references()", opts = { desc = "Clear highlight" } },
				i = { rhs = "lua vim.lsp.buf.implementation()", opts = { desc = "Implementation" } },
				l = { rhs = "lua vim.lsp.codelens.run()", opts = { desc = "Code lens" } },
				n = { rhs = "lua vim.lsp.buf.rename()", opts = { desc = "Rename" } },
				r = { rhs = "lua vim.lsp.buf.references()", opts = { desc = "References" } },
				v = { rhs = "lua vim.lsp.buf.hover()", opts = { desc = "Hover" } },
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
		enabled = false,
		config = function()
			require("lsp_signature").setup({
				wrap = true, -- allow doc/signature text wrap inside floating_window, useful if your lsp return doc/sig is too long
				fix_pos = true, -- set to true, the floating window will not auto-close until finish all parameters
				hint_prefix = "🦆 ",
			})
		end,
		event = "InsertEnter",
	},
}
