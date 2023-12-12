local M = {}

function M.setup(opts)
	opts = opts or {}

	M.set_ft_keymap({
		F = { "lua require('ft-common').toggle_auto_format()", { desc = "Toggle auto format", silent = true } },
	})
end

---@param keys table
function M.set_ft_keymap(keys)
	require("keymap.which-key-helper").register_with_editable("ftplugin", "<LocalLeader>", "<LocalLeader>", keys)
end

function M.toggle_auto_format()
	vim.b.auto_format_disabled = not vim.b.auto_format_disabled
	if vim.b.auto_format_disabled then
		print("Auto format disabled")
	else
		print("Auto format enabled")
	end
end

function M.disable_auto_format()
	vim.b.auto_format_disabled = true
end

---@return boolean
function M.is_auto_format_disabled()
	return vim.b.auto_format_disabled == true
end

return M
