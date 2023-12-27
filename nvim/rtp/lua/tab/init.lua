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

function M.setup(opts)
	opts = opts or {}

	local previous_tab_augroud_id = vim.api.nvim_create_augroup("previous-tab", {})
	vim.api.nvim_create_autocmd("TabClosed", {
		group = previous_tab_augroud_id,
		pattern = "*",
		desc = "Focus previous tab instead of next tab after closing tab",
		callback = function(info)
			local closed_tab_num = info.file
			local max_tab_num = vim.fn.tabpagenr("$")
			local current_tab_num = vim.api.nvim_tabpage_get_number(vim.api.nvim_get_current_tabpage())

			if tonumber(closed_tab_num) > max_tab_num then
				return
			end
			if current_tab_num == 1 then
				return
			end

			vim.cmd("tabprevious")
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
end

return M
