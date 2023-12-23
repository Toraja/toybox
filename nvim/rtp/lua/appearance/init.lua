local M = {}

function M.setup()
	local augroud_id = vim.api.nvim_create_augroup("appearance", {})
	vim.api.nvim_create_autocmd("VimResized", {
		group = augroud_id,
		pattern = "*",
		callback = function()
			vim.cmd("wincmd =")
		end,
	})

	vim.api.nvim_create_autocmd({ "BufWinEnter", "InsertEnter", "InsertLeave" }, {
		group = augroud_id,
		desc = "Highlight trailing whitespaces and mixture of space and tab",
		pattern = "*",
		callback = function()
			local excluded_filetypes = { "help", "toggleterm", "neo-tree" }
			if vim.tbl_contains(excluded_filetypes, vim.opt.filetype:get()) then
				return
			end
			vim.cmd([[syntax match AnnoyingSpaces "\s\+$\| \+\t\+\|\t\+ \+"]])
		end,
	})
end

return M
