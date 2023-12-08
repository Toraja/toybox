local M = {}

function M.setup(opts)
	opts = opts or {}

	vim.keymap.set("t", "<M-\\>", "<C-\\><C-n>", { nowait = true })
	vim.keymap.set("t", "<C-p>", "<Up>")
	vim.keymap.set("t", "<C-n>", "<Down>")
	vim.keymap.set("t", "<C-f>", "<Right>")
	vim.keymap.set("t", "<C-b>", "<Left>")
	vim.keymap.set("t", "<M-f>", "<C-Right>")
	vim.keymap.set("t", "<M-b>", "<C-Left>")
	vim.keymap.set("t", "<C-a>", "<Home>")
	vim.keymap.set("t", "<C-e>", "<End>")
	vim.keymap.set("t", "<C-d>", "<Del>")
	vim.keymap.set("t", "<C-u>", "<Esc>")

	vim.cmd("cnoreabbrev st new <Bar> terminal")
	vim.cmd("cnoreabbrev vt vnew <Bar> terminal")
	vim.cmd("cnoreabbrev tt tabnew <Bar> terminal")

	local terminal_augroud_id = vim.api.nvim_create_augroup("terminal", {})
	vim.api.nvim_create_autocmd("TermOpen", {
		group = terminal_augroud_id,
		desc = "Setup terminal",
		-- Run this autocmd only if the current buffer is terminal, or it enters insert mode even when backgroud terminal job dispatches.
		pattern = "term://*",
		callback = function()
			vim.cmd([[
      syntax clear
      setlocal nonumber signcolumn=no
      startinsert
    ]])
		end,
	})

	vim.api.nvim_create_user_command("TabnewTerminalMulti", function(cmds)
		for _, name in ipairs(cmds.fargs) do
			vim.cmd("tabnew | terminal fish")
			vim.cmd("file " .. name)
		end
	end, { nargs = "+" })
end

return M
