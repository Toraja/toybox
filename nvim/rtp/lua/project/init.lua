local M = {}

---@type string[]
local pj_root_marker_files = {
	".git",
	".svn",
	"Makefile",
	"justfile",
	"package.json",
	"go.mod",
	"Cargo.toml",
}

--- Return the path to the currnet project root. If none of the marker files matches, empty string is returned.
---@param path string Path to begin searching from. If omitted, the current directory is used.
---@return string
function M.get_root_path(path)
	path = path or vim.uv.cwd()
	local found = vim.fs.find(pj_root_marker_files, {
		path = path,
		upward = true,
	})

	if vim.tbl_isempty(found) then
		return ""
	end
	return vim.fs.dirname(found[1])
end

--- lcd to the current project root of the specified buffer.
--- Nothing happens if none of the marker files matches or if current buffer has no name.
---@param buf_id integer
function M.lcd_to_root_path(buf_id)
	local buf_path = vim.api.nvim_buf_get_name(buf_id)
	if buf_path == "" then
		return
	end

	local root_path = M.get_root_path(vim.fs.dirname(buf_path))
	if root_path == "" then
		return
	end

	vim.cmd("lcd " .. root_path)
end

function M.setup()
	local auto_pj_root_augroup_id = vim.api.nvim_create_augroup("auto_pj_root", {})
	vim.api.nvim_create_autocmd("BufEnter", {
		group = auto_pj_root_augroup_id,
		callback = function(params)
			M.lcd_to_root_path(params.buf)
		end,
	})
end

return M
