vim.cmd("runtime! ftplugin/yaml.*")

vim.bo.commentstring = "{{/* %s */}}"

if vim.fn.executable("helm_ls") == 1 then
	require("lspconfig")["helm_ls"].setup({
		capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
	})
end

---@diagnostic disable-next-line: missing-fields
require("nvim-surround").buffer_setup({
	surrounds = {
		v = {
			---@diagnostic disable-next-line: assign-type-mismatch
			add = { "{{ ", " }}" },
			find = function()
				return require("nvim-surround.config").get_selection({ pattern = "{{ [^}]* }}" })
			end,
			---@diagnostic disable-next-line: assign-type-mismatch
			delete = "^(.. ?)().-( ?..)()$",
			change = {
				---@diagnostic disable-next-line: assign-type-mismatch
				target = "({{ ?)()[^}]*( }})()",
			},
		},
		-- -- The below works but not useful
		-- V = {
		--   ---@diagnostic disable-next-line: assign-type-mismatch
		--   add = { "{{ $", " }}" },
		--   find = function()
		--     return surround_config.get_selection({ pattern = '{{ ?%$[^}]* ?}}' })
		--   end,
		--   ---@diagnostic disable-next-line: assign-type-mismatch
		--   delete = '^(....)().-( ?..)()$',
		--   change = {
		--     ---@diagnostic disable-next-line: assign-type-mismatch
		--     target = '({{ %$)()[^}]*( }})()',
		--   },
		-- },
	},
})
