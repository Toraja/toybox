local M = {}

function M.root_path()
	local output = assert(io.popen("git rev-parse --show-toplevel", "r"))
	local root_path = assert(output:read("*a"))
	output:close()
	return vim.fn.fnamemodify(vim.trim(root_path), ":~")
end

function M.is_inside_work_tree()
	local output = assert(io.popen("git rev-parse --is-inside-work-tree", "r"))
	local is_inside_work_tree = assert(output:read("*a"))
	output:close()

	return is_inside_work_tree == true
end

return M
