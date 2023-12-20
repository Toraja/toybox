local M = {}

---@param highlight string
---@return string
local function wrap_highlight(highlight)
	return "%#" .. highlight .. "#"
end

local ignore_modified_ft_list = { "TelescopePrompt" }

-- Add '+' if one of the buffers in the tab page is modified
---@param tab_id integer
---@return string
local function get_modified_symbol(tab_id)
	local win_ids = vim.api.nvim_tabpage_list_wins(tab_id)
	for _, win_id in ipairs(win_ids) do
		local buf_num = vim.api.nvim_win_get_buf(win_id)
		local filetype = vim.api.nvim_buf_get_option(buf_num, "filetype")

		if vim.tbl_contains(ignore_modified_ft_list, filetype) then
			goto continue
		end

		if vim.api.nvim_buf_get_option(buf_num, "modified") then
			return "+"
		end

		::continue::
	end
	return ""
end

local function tabpage_get_buf(tab_id)
	local focused_win_id = vim.api.nvim_tabpage_get_win(tab_id)
	return vim.api.nvim_win_get_buf(focused_win_id)
end

---@param win_id integer
---@return string
---@diagnostic disable-next-line: unused-local,unused-function
local function get_qf_filename(win_id)
	local win_info_dict = vim.fn.getwininfo(win_id)[1]
	if win_info_dict.loclist == 1 then
		return "[Location]"
	elseif win_info_dict.quickfix == 1 then
		return "[Quickfix]"
	end
	return ""
end

local use_alternate_buf_ft_list = { "TelescopePrompt" }

---@param buf_num integer
---@return string
local function get_filename(buf_num)
	local filetype = vim.api.nvim_buf_get_option(buf_num, "filetype")
	local target_buf_num = vim.tbl_contains(use_alternate_buf_ft_list, filetype) and vim.fn.bufnr("#") or buf_num
	local filepath = vim.api.nvim_buf_get_name(target_buf_num)

	if filepath == "" then
		local noname_filetype = vim.api.nvim_buf_get_option(target_buf_num, "filetype")
		if noname_filetype == "qf" then
			return "[Quickfix]"
		end
		return "[No Name]"
	end

	local filename = vim.fs.basename(filepath)
	return filename
end

local function shorten_filename(filename)
	local max_filename_len = 22
	if string.len(filename) <= max_filename_len then
		return filename
	end
	return filename:sub(1, max_filename_len - 1) .. "…" -- Ellipsis: U+2026
end

-- Change devicon's background depending whether the tab is selected
-- devicon on white background is not very nice and a little slower
---@param filetype string
---@param is_tab_selected boolean
---@return string
---@diagnostic disable-next-line: unused-local,unused-function
local function get_devicon_x(filetype, is_tab_selected)
	local devicon, devicon_highlight = require("nvim-web-devicons").get_icon_by_filetype(filetype)
	if devicon == nil then
		return ""
	end

	if not is_tab_selected then
		local devicon_highlight_tabline = devicon_highlight .. "TabLine"
		if vim.tbl_isempty(vim.api.nvim_get_hl(0, { name = devicon_highlight_tabline })) then
			local _, devicon_color = require("nvim-web-devicons").get_icon_color_by_filetype(filetype)
			vim.api.nvim_set_hl(0, devicon_highlight_tabline, { fg = "NONE", bg = devicon_color, reverse = true })
		end
		return wrap_highlight(devicon_highlight_tabline) .. devicon
	end

	return wrap_highlight(devicon_highlight) .. devicon
end

---@param filename string
---@return string
local function get_devicon(filename)
	-- get_icon() handles extension and it does better than this
	-- local extension = filename:match("^.+%.(.+)$")
	local devicon, devicon_highlight = require("nvim-web-devicons").get_icon(filename, nil, { default = true })

	return wrap_highlight(devicon_highlight) .. devicon
end

local separator = wrap_highlight("TabLine")
local tab_fill = wrap_highlight("TabLineFill")
local tab_line_sel = wrap_highlight("TabLineSel")
local tab_line_sel_reverse = wrap_highlight("TabLineSelReverse")
local tab_line = wrap_highlight("TabLine")
local tab_sel_left_symbol = tab_line_sel_reverse .. "" .. tab_line_sel
local tab_sel_right_symbol = tab_line_sel_reverse .. "" .. tab_line

function M.tabline()
	local tabs = {}

	for index, tab_id in ipairs(vim.api.nvim_list_tabpages()) do
		local is_tab_selected = tab_id == vim.api.nvim_get_current_tabpage()
		local highlight_file = is_tab_selected and tab_line_sel or tab_line

		local modified_symbol = get_modified_symbol(tab_id)

		local buf_num = tabpage_get_buf(tab_id)
		local filename = get_filename(buf_num)
		local display_filename = shorten_filename(filename)
		local devicon = get_devicon(filename)

		local tab = " " .. devicon .. " "
		if is_tab_selected then
			tab = tab
				.. tab_sel_left_symbol
				.. string.format("%s%s %s", modified_symbol, index, display_filename)
				.. tab_sel_right_symbol
		else
			tab = tab .. highlight_file .. string.format(" %s%s %s ", modified_symbol, index, display_filename)
		end
		table.insert(tabs, tab)
	end

	-- fill with TabLineFill after the last tab
	return " " .. table.concat(tabs, separator) .. tab_fill
end

-- Add window number if more than 1 is opened
-- let l:wincnt = tabpagewinnr(l:tabpagecnt, '$')
-- if l:wincnt > 1
--   let l:tabtitle .= ':' . l:wincnt
-- endif
--
function M.setup(opts)
	opts = opts or {}

	vim.opt.tabline = "%!v:lua.require('options.tabline').tabline()"
end

return M
