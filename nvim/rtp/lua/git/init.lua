local M = {}

--- Return the git root path of given path, or nil if the given path is not in git repository.
---@param path string? Current directory is used if not specified.
---@return string?
function M.root_path(path)
	path = path or vim.uv.cwd()
	return vim.fs.root(path, { ".git" })
end

--- Return the git root path of given buffer, or nil if the given buffer is not in git repository.
---@param buffer integer? Current buffer is used if not specified.
---@return string?
function M.buf_root_path(buffer)
	buffer = buffer or vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(buffer)
	return M.root_path(path)
end

--- Return the path to the given path relative to git root, or nil if the given path is not in git repository.
---@param path string? Current directory is used if not specified.
---@return string?
function M.relative_path_to_root(path)
	path = path or vim.uv.cwd()
	local git_root = require("git").root_path() .. "/"
	if not git_root then
		return nil
	end
	local relative_path, _ = path:replace(git_root, "")
	return relative_path
end

--- Return the path to the given buffer relative to git root, or nil if the given buffer is not in git repository.
---@param buffer integer? Current buffer is used if not specified.
---@return string?
function M.buf_relative_path_to_root(buffer)
	buffer = buffer or vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(buffer)
	return M.relative_path_to_root(path)
end

--- Returns true if the given path is inside git worktree.
---@param path string? Current directory is used if not specified.
---@return boolean
function M.is_inside_work_tree(path)
	path = path or vim.uv.cwd()
	return vim.fs.root(path, { ".git" }) ~= nil
end

return M
