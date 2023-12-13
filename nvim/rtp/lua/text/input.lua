local M = {}

---@return string|nil
function M.get_input(prompt)
	local ok, result = pcall(vim.fn.input, { prompt = prompt, cancelreturn = vim.NIL })
	-- vim.cmd("redraw!") -- XXX does not clear commandline
	if ok and result ~= vim.NIL then
		return result
	end
end

return M
