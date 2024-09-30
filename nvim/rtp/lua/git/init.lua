local M = {}

function M.root_path()
	local output = assert(io.popen("git rev-parse --show-toplevel", "r"))
	local root_path = assert(output:read("*a"))
	output:close()
	return string.gsub(vim.trim(root_path), "^" .. vim.uv.os_homedir(), "~", 1)
end

---@return boolean
function M.is_inside_work_tree()
	local output = assert(io.popen("git rev-parse --is-inside-work-tree 2>/dev/null", "r"))
	local is_inside_work_tree = vim.trim(assert(output:read("*a")))
	output:close()

	return is_inside_work_tree == "true"
end

return M
