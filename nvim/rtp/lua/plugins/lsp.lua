return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- TODO
			-- 'java': [$HOME.'/toybox/vim/helper/java-lsp.sh', '-data', vim.uv.cwd()],
			-- 'javascript': ['typescript-language-server', '--stdio'],
			-- 'php': [s:plugin_dir . '/phpactor/bin/phpactor', 'language-server'],

			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
			vim.api.nvim_set_hl(0, "LspReferenceText", { fg = "#abb2bf", reverse = true })
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
				opts.max_width = opts.max_width or 100
				return orig_util_open_floating_preview(contents, syntax, opts, ...)
			end

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
								enabled = false, -- adding custome schema does not work. LSP emits 'Changing workspace config is not implemented'.
								config = {
									schemas = {
										Kubernetes = "templates/**",
										["https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1beta1.json"] = "templates/**",
									},
								},
							},
						},
					},
				}
			end
			if vim.fn.executable("pyright") == 1 then
				servers.pyright = {}
			end
			-- if vim.fn.executable("rust-analyzer") == 1 then
			-- this is setup inside rustaceanvim
			-- 	table.insert(servers, "rust_analyzer")
			-- end
			if vim.fn.executable("taplo") == 1 then
				servers.taplo = {}
			end
			if vim.fn.executable("yaml-language-server") == 1 then
				servers.yamlls = {
					settings = {
						yaml = {
							customTags = { -- FIXME: this does not work https://docs.gitlab.com/ee/ci/yaml/yaml_optimization.html#configure-your-ide-to-support-reference-tags
								"!reference sequence",
							},
						},
					},
				}
			end
			for lsp, setting in pairs(servers) do
				lspconfig[lsp].setup(vim.tbl_extend("force", { capabilities = capabilities }, setting))
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
				a = { "lua vim.lsp.buf.code_action()", { desc = "Code action" } },
				c = { "lua vim.lsp.buf.incoming_calls()", { desc = "Incoming calls" } },
				C = { "lua vim.lsp.buf.outgoing_calls()", { desc = "Outgoing calls" } },
				d = { "lua vim.diagnostic.setloclist()", { desc = "Diagnostic (buffer)" } },
				D = { "lua vim.diagnostic.setqflist()", { desc = "Diagnostic (all)" } },
				f = { "lua vim.lsp.buf.format({ async = true })", { desc = "Format" } },
				h = { "lua vim.lsp.buf.document_highlight()", { desc = "Highlight symbol" } },
				H = { "lua vim.lsp.buf.clear_references()", { desc = "Clear highlight" } },
				i = { "lua vim.lsp.buf.implementation()", { desc = "Implementation" } },
				l = { "lua vim.lsp.codelens.run()", { desc = "Code lens" } },
				n = { "lua vim.lsp.buf.rename()", { desc = "Rename" } },
				r = { "lua vim.lsp.buf.references()", { desc = "References" } },
				v = { "lua vim.lsp.buf.hover()", { desc = "Hover" } },
			})
		end,
	},
	{
		"ray-x/lsp_signature.nvim",
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
