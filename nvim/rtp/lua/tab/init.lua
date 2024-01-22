local M = {}

local LastTab = {
	id = 1,
}

function M.focus_last_tab()
	if not vim.api.nvim_tabpage_is_valid(LastTab.id) then
		vim.notify(
			string.format("tabpage %s does not exist.", LastTab.id),
			vim.log.levels.WARN,
			{ title = "focus last tab" }
		)
		return
	end
	vim.api.nvim_set_current_tabpage(LastTab.id)
end

local tab_name_var_name = "tabname"

---@param buf_num integer
---@param name string
function M.set_tab_name(buf_num, name)
	vim.api.nvim_buf_set_var(buf_num, tab_name_var_name, name)
end

---@param buf_num integer
---@return boolean exists
---@return string name
function M.get_tab_name(buf_num)
	local exists, name = pcall(vim.api.nvim_buf_get_var, buf_num, "tabname")
	return exists, name
end

function M.setup(opts)
	opts = opts or {}

	local previous_tab_augroud_id = vim.api.nvim_create_augroup("previous-tab", {})
	vim.api.nvim_create_autocmd("TabClosed", {
		group = previous_tab_augroud_id,
		pattern = "*",
		desc = "Focus previous tab instead of next tab after closing tab",
		callback = function(info)
			local closed_tab_num = tonumber(info.file)
			local current_tab_num = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())

			-- By default, nvim focuses the tab on the right when a tab is closed.
			-- So if the current tab number is same as the closed tab number, it means
			-- the focused tab was closed.
			-- Moving to the previous tab should be performed only when a focused tab
			-- was closed (not `{count}tabclose`), except when the first tab is closed.
			if closed_tab_num == current_tab_num and closed_tab_num ~= 1 then
				vim.cmd("tabprevious")
			end
		end,
	})

	local last_tab_augroud_id = vim.api.nvim_create_augroup("last-tab", {})
	vim.api.nvim_create_autocmd("TabLeave", {
		group = last_tab_augroud_id,
		pattern = "*",
		desc = "Store last tabpage number",
		callback = function()
			LastTab.id = vim.api.nvim_get_current_tabpage()
		end,
	})

	vim.cmd("cnoreabbrev tn tabnew")
	vim.cmd("cnoreabbrev th tab help")
end

return M
