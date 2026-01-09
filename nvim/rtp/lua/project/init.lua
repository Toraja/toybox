local M = {}

---@type string[][]
-- Quoted from `:h vim.fs.root()`
-- > To indicate "equal priority", specify items in a nested list `{ { 'a.txt', 'b.lua' }, … }`.
local pj_root_markers = {
	{
		".git",
		".svn",
		"Makefile",
		"justfile",
		"package.json",
		"go.mod",
		"Cargo.toml",
	},
}

--- Return the path to the currnet project root. If none of the marker files matches, current working directory is returned.
---@param path string? Path to begin searching from. Current directory is used if omitted.
---@return string
function M.get_root_path(path)
	local cwd = vim.uv.cwd()
	path = path or cwd

	return vim.fs.root(path, pj_root_markers) or cwd
end

function M.setup()
	local auto_pj_root_augroup_id = vim.api.nvim_create_augroup("auto_pj_root", {})
	vim.api.nvim_create_autocmd("BufEnter", {
		group = auto_pj_root_augroup_id,
		callback = function(params)
			local root = vim.fs.root(params.buf, pj_root_markers)
			if not root then
				return
			end
			vim.cmd("lcd " .. root)
		end,
	})
end

return M
