local M = {}

---@param tab_id integer
---@return string
local function get_highlight(tab_id)
	if tab_id == vim.api.nvim_get_current_tabpage() then
		return "%#TabLineSel#"
	end
	return "%#TabLine#"
end

-- Add '+' if one of the buffers in the tab page is modified
---@param tab_id integer
---@return string
local function get_modified_symbol(tab_id)
	local win_ids = vim.api.nvim_tabpage_list_wins(tab_id)
	for _, win_id in ipairs(win_ids) do
		local buf_num = vim.api.nvim_win_get_buf(win_id)
		if vim.api.nvim_buf_get_option(buf_num, "modified") then
			return "+"
		end
	end
	return ""
end

---@param tab_id integer
---@return string
local function get_filename(tab_id)
	local current_win_id = vim.api.nvim_tabpage_get_win(tab_id)
	local current_buf_num = vim.api.nvim_win_get_buf(current_win_id)
	local filepath = vim.api.nvim_buf_get_name(current_buf_num)

	if string.len(filepath) == 0 then
		local win_info_dict = vim.fn.getwininfo(current_win_id)[1]
		if win_info_dict.loclist == 1 then
			return "[Location]"
		elseif win_info_dict.quickfix == 1 then
			return "[Quickfix]"
		end

		return "[No Name]"
	end

	filename = vim.fs.basename(filepath)
	local max_fname_length = 20
	if string.len(filename) > max_fname_length then
		return string.sub(filename, 1, max_fname_length)
	end
	return filename
end

function M.tabline()
	local tabs = {}

	for index, tab_id in ipairs(vim.api.nvim_list_tabpages()) do
		local highlight = get_highlight(tab_id)
		local modified_symbol = get_modified_symbol(tab_id)
		local filename = get_filename(tab_id)
		table.insert(tabs, string.format("%s %s%s %s ", highlight, modified_symbol, index, filename))
	end

	-- fill with TabLineFill after the last tab
	return " " .. table.concat(tabs, "%#TabLine#|") .. "%#TabLineFill#"
end

-- Add window number if more than 1 is opened
-- let l:wincnt = tabpagewinnr(l:tabpagecnt, '$')
-- if l:wincnt > 1
--   let l:tabtitle .= ':' . l:wincnt
-- endif

return M
