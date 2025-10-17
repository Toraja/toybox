--- Performs plain substring replacement, with no characters in `pattern` or `replacement` being considered magic.
---@param s string
---@param pattern string
---@param replacement string
---@param n number? number of replacements to make; defaults to all occurrences
---@return string
---@return number
function string.replace(s, pattern, replacement, n)
	return string.gsub(s, string.gsub(pattern, "%p", "%%%0"), string.gsub(replacement, "%%", "%%%%"), n)
end
