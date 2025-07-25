local M = {}

--- Appends a string to the current line if it doesn't already end with that string.
--- @param str string The string to append.
function M.append_trailing(str)
	local line_str = vim.api.nvim_get_current_line()
	if vim.endswith(line_str, str) then
		return
	end
	vim.api.nvim_set_current_line(line_str .. str)
end

--- Appends a suffix to a string if it doesn't already end with it, otherwise removes the suffix.
--- @param str string The input string.
--- @param suffix string The suffix to append or remove.
--- @return string The modified string.
local function append_or_remove_suffix(str, suffix)
	if vim.endswith(str, suffix) then
		return string.sub(str, 1, string.len(str) - string.len(suffix))
	end
	return str .. suffix
end

--- Toggles a trailing string for the current line.
--- @param str string The string to append or remove.
function M.toggle_trailing_current(str)
	vim.api.nvim_set_current_line(append_or_remove_suffix(vim.api.nvim_get_current_line(), str))
end

--- Toggles a trailing string for visually selected lines.
--- If a line ends with `str`, it is removed. Otherwise, `str` is appended to the line.
--- @param str string The string to append or remove.
function M.toggle_trailing_visual(str)
	local line_num_current = vim.fn.line("v")
	local line_num_other_end = vim.fn.line(".")
	local start_line_num = math.min(line_num_current, line_num_other_end)
	local end_line_num = math.max(line_num_current, line_num_other_end)

	local target_lines = vim.api.nvim_buf_get_lines(0, start_line_num - 1, end_line_num, false)
	local new_lines = {}
	for _, line in ipairs(target_lines) do
		table.insert(new_lines, append_or_remove_suffix(line, str))
	end
	vim.api.nvim_buf_set_lines(0, start_line_num - 1, end_line_num, false, new_lines)
end

--- Maps a key to toggle trailing characters (e.g., spaces or commas) in the current line or visual selection.
--- @param key string The key is mapped with meta key (e.g. 's' will be <M-s>).
--- @param str string The string of characters to toggle (e.g., ' ' for spaces, ',' for commas).
--- @param buffer integer|boolean? Pass as {opts.buffer} of `vim.keymap.set()`
function M.map_toggle_trailing(key, str, buffer)
	vim.keymap.set({ "n", "i" }, "<M-" .. key .. ">", function()
		require("text.edit").toggle_trailing_current(str)
	end, { silent = true, buffer = buffer })
	vim.keymap.set("x", "<M-" .. key .. ">", function()
		require("text.edit").toggle_trailing_visual(str)
	end, { silent = true, buffer = buffer })
end

return M
