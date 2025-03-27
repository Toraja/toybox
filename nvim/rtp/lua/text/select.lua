local M = {}

---@param bufnr integer
---@return string
function M.get_visual_text(bufnr)
	local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(bufnr, "<"))
	local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, ">"))
	local last_char = vim.api.nvim_buf_get_text(bufnr, end_row - 1, end_col, end_row - 1, end_col + 1, {})[1]
	local last_char_byte_len = vim.str_byteindex(last_char, 1) -- adjust for multibyte character
	end_col = end_col + last_char_byte_len
	local selection = vim.api.nvim_buf_get_text(bufnr, start_row - 1, start_col, end_row - 1, end_col, {})
	local regex_any_line_break = "\\_$\\_s" -- see :help /ordinary-atom
	return table.concat(selection, regex_any_line_break)
end

-- This functin is not intended to be set as operatorfunc, but rather called from operatorfunc.
---@param bufnr integer
---@return string
function M.get_operator_text(bufnr)
	local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(bufnr, "["))
	local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(bufnr, "]"))
	return vim.api.nvim_buf_get_text(bufnr, start_row - 1, start_col, end_row - 1, end_col + 1, {})
end

-- To set lua function to operatorfunc, importing module must be without parentheses and,
-- single quotation must be used.
-- vim.opt.operatorfunc = "v:lua.require'module'.func"
-- ref: https://github.com/neovim/neovim/issues/14157#issuecomment-1499300747,
---@param func_name string
function M.invoke_operator_func(func_name)
	vim.opt.operatorfunc = "v:lua." .. func_name
	vim.api.nvim_echo({ { "operatorfunc: ", "Normal" }, { func_name, "Identifier" } }, false, {})
	vim.api.nvim_feedkeys("g@", "n", false)
end

-- About operatorfunc
-- Function that is set to `operatorfunc` is called with operator type as an argument.
-- The possible value differs depending on the mode (operator or visual).
-- For operator, it is either 'char' (single line) or 'line' (multiline).
-- For visual, it is one of 'char' (`v` selection), 'line' (`V`), or `block` (`<C-v>`).
-- ---
-- To invoke operatorfunc, set a function to operatorfunc option and type `g@`.
-- If typed in normal mode, it blocks and wait for motion key.
-- If typed in visual mode, it the function is called right away.

return M
