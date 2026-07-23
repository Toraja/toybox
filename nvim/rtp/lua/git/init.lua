local M = {}

---@param path string? current directory is used if not specified
---@return string? git root path, or nil if the given path is not in git repository
function M.root_path(path)
	path = path or vim.uv.cwd()
	return vim.fs.root(path, { ".git" })
end

---@param buffer integer? current buffer is used if not specified
---@return string? git root path of the buffer, or nil if the given buffer is not in git repository
function M.buf_root_path(buffer)
	buffer = buffer or vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(buffer)
	return M.root_path(path)
end

---@param path string? current directory is used if not specified
---@return string? path relative to git root, or nil if the given path is not in git repository
function M.relative_path_to_root(path)
	path = path or vim.uv.cwd()
	local git_root = require("git").root_path() .. "/"
	if not git_root then
		return nil
	end
	local relative_path, _ = path:replace(git_root, "")
	return relative_path
end

---@param buffer integer? current buffer is used if not specified
---@return string? path relative to git root of the buffer, or nil if the given buffer is not in git repository
function M.buf_relative_path_to_root(buffer)
	buffer = buffer or vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(buffer)
	return M.relative_path_to_root(path)
end

---@param relative_path string relative path from the git repository root
---@return boolean? true if the file exists, nil if the current directory is not inside a git repository
function M.file_exists(relative_path)
	local git_root = M.root_path()
	if not git_root then
		return nil
	end
	local full_path = git_root .. "/" .. relative_path
	return vim.uv.fs_stat(full_path) ~= nil
end

---@param path string? current directory is used if not specified
---@return boolean true if the given path is inside git worktree
function M.is_inside_work_tree(path)
	path = path or vim.uv.cwd()
	return vim.fs.root(path, { ".git" }) ~= nil
end

return M
