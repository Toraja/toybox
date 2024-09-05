vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = false

require("lspconfig")["lua_ls"].setup({
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
})
