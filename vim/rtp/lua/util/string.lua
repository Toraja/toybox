local M = {}

--- Test if the string ends in the given substring
-- @param s (string) string to test
-- @param suffix (string) suffix
function M.has_suffix(s, suffix)
  return s:sub( -string.len(suffix)) == suffix
end

return M
