local M = {}

--- Return the root path of given git repository, or nil if the given path is not git repository.
---@param path string? Current directory is used if not specified.
---@return string?
function M.root_path(path)
	path = path or vim.uv.cwd()
	return vim.fs.root(path, { ".git" })
end

--- Returns true if the given path is inside git worktree.
---@param path string? Current directory is used if not specified.
---@return boolean
function M.is_inside_work_tree(path)
	path = path or vim.uv.cwd()
	return vim.fs.root(path, { ".git" }) ~= nil
end

return M
