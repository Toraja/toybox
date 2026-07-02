vim.cmd("runtime! ftplugin/yaml.*")

vim.bo.commentstring = "{{/* %s */}}"

---@diagnostic disable-next-line: missing-fields
require("nvim-surround").buffer_setup({
	surrounds = {
		v = {
			---@diagnostic disable-next-line: assign-type-mismatch
			add = { "{{ ", " }}" },
			find = function()
				return require("nvim-surround.config").get_selection({ pattern = "{{%s?[^}]*%s?}}" })
			end,
			---@diagnostic disable-next-line: assign-type-mismatch
			delete = "({{%s?)().-(%s?}})()",
			change = {
				---@diagnostic disable-next-line: assign-type-mismatch
				target = "({{%s?)().-(%s?}})()",
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
