local M = {}

function M.delete_hidden_buffers()
	local function delete_buffer_if_hidden(buf)
		if buf.hidden == 1 then
			vim.api.nvim_buf_delete(buf.bufnr, {})
		end
	end
	local buffers = vim.fn.getbufinfo({ buflisted = true, bufloaded = true })
	vim.tbl_map(delete_buffer_if_hidden, buffers)
end

function M.delete_all_buffers()
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		vim.api.nvim_buf_delete(buf, {})
	end
end

function M.setup(opts)
	opts = opts or {}

	local augroud_id = vim.api.nvim_create_augroup("buffer-init", {})
	vim.api.nvim_create_autocmd("BufReadPost", {
		group = augroud_id,
		pattern = "*",
		callback = function()
			-- jump to the last focused line when reopening a file
			local last_forcused_line = vim.fn.line("'\"")
			local last_forcused_column = math.max(vim.fn.col("'\"") - 1, 0) -- avoid column to be negative number
			if last_forcused_line > 1 and last_forcused_line <= vim.fn.line("$") then
				vim.api.nvim_win_set_cursor(0, { last_forcused_line, last_forcused_column })
			end
		end,
	})

	vim.api.nvim_create_user_command("BufDeleteHidden", M.delete_hidden_buffers, {})
	vim.api.nvim_create_user_command("BufDeleteAll", M.delete_all_buffers, {})
	vim.cmd("cnoreabbrev bdh BufDeleteHidden")
	vim.cmd("cnoreabbrev bda BufDeleteAll")
end

return M
