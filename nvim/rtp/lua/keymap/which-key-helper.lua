local M = {}

local function wrap_as_cmd(cmd)
	return "<Cmd>" .. cmd .. "<CR>"
end

local function wrap_as_editable(cmd)
	return ":" .. cmd .. " "
end

function M.register_with_editable(prompt, prefix_key, edit_key, cmds, opts)
	local edit_prefix_key = prefix_key .. edit_key
	local wk = require("which-key")
	-- Use which-key only to set the name of grouping
	wk.add({
		{ prefix_key, group = prompt, opts },
		{ edit_prefix_key, group = "Edit command", opts },
	})

	for key, cmd in pairs(cmds) do
		if type(cmd[1]) == "function" then
			vim.keymap.set("n", prefix_key .. key, cmd[1], cmd[2])
			goto continue
		end

		vim.keymap.set("n", prefix_key .. key, wrap_as_cmd(cmd[1]), cmd[2])
		vim.keymap.set("n", edit_prefix_key .. key, wrap_as_editable(cmd[1]), cmd[2])

		::continue::
	end
end

local function make_cmds_buffer_local(cmds)
	for _, cmd in pairs(cmds) do
		cmd[2].buffer = true
	end
end

function M.register_for_ftplugin(cmds)
	make_cmds_buffer_local(cmds)
	---@diagnostic disable-next-line: undefined-field
	M.register_with_editable(vim.opt.filetype:get(), "<LocalLeader>", "<LocalLeader>", cmds, { buffer = 0 })
end

return M
