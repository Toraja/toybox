local M = {}

function M.setup(opts)
	opts = opts or {}

	vim.diagnostic.config({ virtual_text = { current_line = true } })
end

return M
