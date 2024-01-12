local M = {}

---@param highlight string
---@return string
local function wrap_highlight(highlight)
	return "%#" .. highlight .. "#"
end

local ignore_modified_ft_list = { "TelescopePrompt", "dap-repl" }
local use_alternate_buf_ft_list = { "TelescopePrompt", "qf" }

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

local hl_tab_line_fill = wrap_highlight("TabLineFill")
local hl_tab_line_sel = wrap_highlight("TabLineSel")
local hl_tab_line_sel_separator = wrap_highlight("TabLineSelSeparator")
local hl_tab_line = wrap_highlight("TabLine")
local tab_sel_left_sep = hl_tab_line_sel_separator .. "" .. hl_tab_line_sel
local tab_sel_right_sep = hl_tab_line_sel_separator .. "" .. hl_tab_line
local tab_line_left_sep = hl_tab_line .. " "
local tab_line_right_sep = " "
local hl_logo_left = wrap_highlight("TabLineLogoLeft")
local hl_logo_right = wrap_highlight("TabLineLogoRight")
local logo = hl_logo_left .. "  N" .. hl_logo_right .. "VIM  "
local logo_width = 8
local logo_half_width = logo_width / 2

---@class Tab
---@field tab_index integer
---@field tab_id integer
---@field selected boolean
---@field target_buf_num integer
---@field buftype string
---@field filetype string
---@field name string
---@field modified_symbol string
---@field devicon string
---@field devicon_highlight string
---@field occupying_width integer
local Tab = {}

---@param tab_index integer
---@param tab_id integer
---@return Tab
function Tab:new(tab_index, tab_id)
	local tab = setmetatable({
		modified_symbol = "",
		occupying_width = 0,
	}, { __index = self })

	tab.tab_index = tab_index
	tab:add_occupying_width(string.len(tab_index))
	tab.tab_id = tab_id
	tab.selected = tab_id == vim.api.nvim_get_current_tabpage()
	tab:set_target_buf_num()
	tab.buftype = vim.api.nvim_buf_get_option(tab.target_buf_num, "buftype")
	-- tab.filetype = vim.api.nvim_buf_get_option(tab.target_buf_num, "filetype")
	tab:set_name()
	tab:set_devicon()
	tab:set_modified_symbol()
	tab:add_occupying_width(5) -- spacing

	return tab
end

---@param max_width integer
---@return string rendered_tab
function Tab:render(max_width)
	local display_name = self.name
	if self.occupying_width > max_width then
		local diff = self.occupying_width - max_width
		local name_len = string.len(self.name)
		display_name = self.name:sub(1, name_len - diff - 1) .. "…" -- Ellipsis: U+2026
	end

	local left_sep, right_sep
	if self.selected then
		left_sep = tab_sel_left_sep
		right_sep = tab_sel_right_sep
	else
		left_sep = tab_line_left_sep
		right_sep = tab_line_right_sep
	end

	return string.format(
		" %s %s%s%s %s%s",
		wrap_highlight(self.devicon_highlight) .. self.devicon,
		left_sep,
		self.modified_symbol,
		self.tab_index,
		display_name,
		right_sep
	)
end

---@param n integer
function Tab:add_occupying_width(n)
	self.occupying_width = self.occupying_width + n
end

function Tab:set_target_buf_num()
	local focused_win_id = vim.api.nvim_tabpage_get_win(self.tab_id)
	local focused_buf_num = vim.api.nvim_win_get_buf(focused_win_id)
	local filetype = vim.api.nvim_buf_get_option(focused_buf_num, "filetype")
	target_buf_num = vim.tbl_contains(use_alternate_buf_ft_list, filetype) and vim.fn.bufnr("#") or focused_buf_num
	self.target_buf_num = target_buf_num
end

function Tab:set_name()
	local exists, tabname = require("tab").get_tab_name(self.tab_id)
	if exists then
		self.name = tabname
	else
		local filepath = vim.api.nvim_buf_get_name(target_buf_num)
		if filepath == "" then
			self.name = "[No Name]"
		else
			self.name = vim.fs.basename(filepath)
		end
	end

	self:add_occupying_width(string.len(self.name))
end

function Tab:set_devicon()
	local devicons = require("nvim-web-devicons")
	if self.buftype == "terminal" then
		self.devicon, self.devicon_highlight = devicons.get_icon("bash", nil)
	else
		self.devicon, self.devicon_highlight = devicons.get_icon(self.name, nil, { default = true })
	end
	self:add_occupying_width(1)
end

function Tab:set_modified_symbol()
	local win_ids = vim.api.nvim_tabpage_list_wins(self.tab_id)
	for _, win_id in ipairs(win_ids) do
		local buf_num = vim.api.nvim_win_get_buf(win_id)
		local filetype = vim.api.nvim_buf_get_option(buf_num, "filetype")

		if vim.tbl_contains(ignore_modified_ft_list, filetype) then
			goto continue
		end

		if vim.api.nvim_buf_get_option(buf_num, "modified") then
			self.modified_symbol = "+"
			self:add_occupying_width(1)
			return
		end

		::continue::
	end
end

function M.tabline()
	local vim_columns = vim.opt.columns:get()
	local truncate_threshold = vim_columns - logo_width - 2 -- 2 for truncate indicator
	local tabpages = vim.api.nvim_list_tabpages()
	local tab_count = vim.tbl_count(tabpages)
	local max_tab_width = math.max(math.floor(truncate_threshold / tab_count), 22)

	local tabs = ""
	local current_width = 0
	for index = tab_count, 1, -1 do
		local tab_id = tabpages[index]
		local tab = Tab:new(index, tab_id)
		local width = math.min(tab.occupying_width, max_tab_width)
		local next_width = current_width + width
		if next_width > truncate_threshold then
			tabs = " <" .. tabs
			-- tabs = "⟨" .. tabs -- Mathematical Left Angle Bracket: U+27E8
			break
		end
		current_width = next_width
		tabs = Tab:new(index, tab_id):render(width) .. tabs
	end

	local remaining_width = truncate_threshold - current_width
	local padding_width = math.floor(remaining_width / 2) - logo_half_width
	local padding = string.rep(" ", padding_width)

	return logo .. hl_tab_line .. padding .. tabs .. hl_tab_line_fill
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
