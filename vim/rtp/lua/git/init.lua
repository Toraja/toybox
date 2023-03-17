local M = {}

function M.root_path()
  local file = assert(io.popen('git rev-parse --show-toplevel', 'r'))
  local contents = assert(file:read('*a'))
  file:close()
  return vim.fn.fnamemodify(vim.trim(contents), ':~')
end

return M
