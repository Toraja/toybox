local M = {}

function M.preserve_cursor(func)
	local current_win = vim.api.nvim_get_current_win()
	local cursor_position = vim.api.nvim_win_get_cursor(0)
	func()
	vim.api.nvim_set_current_win(current_win)
	vim.api.nvim_win_set_cursor(current_win, cursor_position)
end

return M
