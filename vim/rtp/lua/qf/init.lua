local M = {}

local function quickfix_list_toggle()
	local qf_win_id = vim.fn.getqflist({ winid = 0 }).winid
	if qf_win_id == 0 then
		local current_win_id = vim.fn.win_getid()
		if not pcall(function()
			vim.cmd("copen")
		end) then
			print("No quickfix list")
			return
		end
		vim.fn.win_gotoid(current_win_id)
	else
		vim.cmd("cclose")
	end
end

local function location_list_toggle()
	local loclist_win_id = vim.fn.getloclist(0, { winid = 0 }).winid
	if loclist_win_id == 0 then
		local current_win_id = vim.fn.win_getid()
		if not pcall(function()
			vim.cmd("lopen")
		end) then
			print("No location list")
			return
		end
		vim.fn.win_gotoid(current_win_id)
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

	local current_tab_number = vim.fn.tabpagenr()
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

	vim.cmd("tabnext " .. current_tab_number)
end

function M.setup(opts)
	opts = opts or {}
	vim.keymap.set("n", "<C-q><C-q>", quickfix_list_toggle, { desc = "Toggle quickfix window" })
	vim.keymap.set("n", "<C-q><C-l>", location_list_toggle, { desc = "Toggle loation list window" })

	vim.api.nvim_create_user_command("QfFilesOpen", qf_files_open, {})
end

return M
