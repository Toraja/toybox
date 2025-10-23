local M = {}

local function new_terminal(opts)
	opts = opts or {}

	if opts.name then
		require("tab").set_tab_name(0, opts.name)
	end

	local cmd = opts.cmd or "fish"

	vim.fn.jobstart(cmd, {
		on_exit = function()
			if not opts.keep_buffer then
				vim.api.nvim_buf_delete(0, { force = true })
			end
		end,
		term = true,
	})
end

function M.setup(opts)
	opts = opts or {}

	vim.keymap.set("t", "<C-\\>", "<C-\\><C-n>", { nowait = true })
	for i = 1, 9 do
		vim.keymap.set("t", "<M-" .. i .. ">", function()
			vim.cmd("stopinsert") -- cursor disappears without `stopinsert`
			vim.cmd("tabnext " .. i)
		end)
	end
	vim.keymap.set("t", "<M-0>", function()
		vim.cmd("stopinsert")
		vim.cmd("tabnext 10")
	end)

	vim.api.nvim_create_user_command("Terminal", function(cmds)
		local open_terminal_opts = {}
		for _, arg in pairs(cmds.fargs) do
			local opt_key, opt_val = vim.split(arg, "=")
			if not opt_val then
				vim.api.nvim_echo({ "invalid argument: " .. arg, "WarningMsg" }, true, {})
				return
			end
			open_terminal_opts[opt_key] = opt_val
		end

		new_terminal(open_terminal_opts)
	end, {})

	vim.cmd("cnoreabbrev st new <Bar> Terminal")
	vim.cmd("cnoreabbrev vt vnew <Bar> Terminal")
	vim.cmd("cnoreabbrev tt tabnew <Bar> Terminal")

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
			vim.cmd("tabnew")
			new_terminal({ name = name })
		end
	end, { nargs = "+" })

	vim.cmd("cnoreabbrev ttm TabnewTerminalMulti")
end

return M
