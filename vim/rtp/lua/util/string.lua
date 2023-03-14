local M = {}

function M.has_suffix(s, suffix)
  return s:sub( -string.len(suffix)) == suffix
end

return M
