return {
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- TODO
			-- 'java': [$HOME.'/toybox/vim/helper/java-lsp.sh', '-data', getcwd()],
			-- 'javascript': ['typescript-language-server', '--stdio'],
			-- 'php': [s:plugin_dir . '/phpactor/bin/phpactor', 'language-server'],

			vim.api.nvim_set_hl(0, "NormalFloat", { link = "Normal" })
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
				d = { "lua vim.diagnostic.setloclist()", { desc = "Diagnostic (location)" } },
				D = { "lua vim.diagnostic.setqflist()", { desc = "Diagnostic (quickfix)" } },
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
	},
}
