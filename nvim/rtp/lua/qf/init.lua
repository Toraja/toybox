local M = {}

local function quickfix_list_toggle()
	local qf_win_id = vim.fn.getqflist({ winid = 0 }).winid
	if qf_win_id == 0 then
		local current_win_id = vim.api.nvim_get_current_win()
		if not pcall(function()
			vim.cmd("copen")
		end) then
			print("No quickfix list")
			return
		end
		vim.api.nvim_set_current_win(current_win_id)
	else
		vim.cmd("cclose")
	end
end

local function location_list_toggle()
	local loclist_win_id = vim.fn.getloclist(0, { winid = 0 }).winid
	if loclist_win_id == 0 then
		local current_win_id = vim.api.nvim_get_current_win()
		if not pcall(function()
			vim.cmd("lopen")
		end) then
			print("No location list")
			return
		end
		vim.api.nvim_set_current_win(current_win_id)
	else
		vim.cmd("lclose")
	end
end

local function qf_files_open()
	local qflist = vim.fn.getqflist()
	if vim.tbl_isempty(qflist) then
		print("qflist is empty")
		return
	end

	local current_tab_id = vim.api.nvim_get_current_tabpage()
	-- Newly opened tab seems to inherits the same option of current win.
	-- nvim-bqf sets `signcolumn` to `number` in qf window so close qf window here
	-- to make sure that current forcus is not on qf window.
	vim.cmd("cclose")

	vim.tbl_map(function(qf)
		local file_bufnr = qf["bufnr"]
		if not file_bufnr then
			print(string.format('buffer number for "%s" is not present', qf["text"]))
			return
		end

		vim.cmd("tab sbuffer " .. file_bufnr)
		vim.api.nvim_win_set_cursor(0, { qf["lnum"], qf["col"] - 1 })
	end, qflist)

	vim.api.nvim_set_current_tabpage(current_tab_id)
end

---@param win_id integer
function M.is_loclist_win(win_id)
	local win_info_dict = vim.fn.getwininfo(win_id)[1]
	return win_info_dict.loclist == 1
end

function M.setup(opts)
	opts = opts or {}
	vim.keymap.set("n", "<C-q><C-q>", quickfix_list_toggle, { desc = "Toggle quickfix window" })
	vim.keymap.set("n", "<C-q><C-l>", location_list_toggle, { desc = "Toggle loation list window" })
	vim.keymap.set("n", "<C-q><C-o>", qf_files_open, { desc = "Open files in quickfix list" })

	vim.api.nvim_create_user_command("QfFilesOpen", qf_files_open, {})

	local augroud_id = vim.api.nvim_create_augroup("quickfix", {})
	vim.api.nvim_create_autocmd("FileType", {
		group = augroud_id,
		pattern = "qf",
		callback = function()
			vim.opt_local.relativenumber = false
		end,
	})
end

return M
