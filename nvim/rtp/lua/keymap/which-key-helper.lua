local M = {}

local function wrap_as_cmd(cmd)
	return "<Cmd>" .. cmd .. "<CR>"
end

local function wrap_as_editable(cmd)
	return ":" .. cmd .. " "
end

--- Registers keymaps with an editable option.
--- This function sets up keymaps, allowing for an 'editable' version of each command.
--- If the `rhs` of a keymap is a function, the editable version will not be set.
---
--- @param prompt string The prompt/group name for the keymaps.
--- @param prefix_key string The prefix key for the main keymaps (e.g., '<leader>r').
--- @param edit_key string The extra prefix key for the editable commands (e.g., 'e').
--- @param keymaps table<string, {rhs: string|function, mode: string|string[]?, opts: table?}> A table of keymap definitions. The table key is the suffix of the keymap, `rhs`, `mode` and `opts` are passed as {rhs}, {mode} and {opts} of `vim.keymap.set` respectively. `mode` will default to "n" if not provided.
--- @param opts table|nil Optional table of options to pass to `which-key.add`.
function M.register_with_editable(prompt, prefix_key, edit_key, keymaps, opts)
	local edit_prefix_key = prefix_key .. edit_key
	local opts = opts or {}
	local wk = require("which-key")

	-- Use which-key only to set the name of grouping
	wk.add({
		{ prefix_key, group = prompt, opts },
		{ edit_prefix_key, group = "Edit command", opts },
	})

	for key, keymap in pairs(keymaps) do
		local mode = keymap.mode or { "n" }

		if type(keymap.rhs) == "function" then
			vim.keymap.set(mode, prefix_key .. key, keymap.rhs, keymap.opts)
			goto continue
		end

		vim.keymap.set(mode, prefix_key .. key, wrap_as_cmd(keymap.rhs), keymap.opts)
		vim.keymap.set(mode, edit_prefix_key .. key, wrap_as_editable(keymap.rhs), keymap.opts)

		::continue::
	end
end

--- @param keymaps table Same as `keymaps` of M.register_with_editable
local function make_keymaps_buffer_local(keymaps)
	for _, keymap in pairs(keymaps) do
		keymap.opts.buffer = true
	end
end

--- @param keymaps table Same as `keymaps` of M.register_with_editable
function M.register_for_ftplugin(keymaps)
	make_keymaps_buffer_local(keymaps)
	---@diagnostic disable-next-line: undefined-field
	M.register_with_editable(vim.opt.filetype:get(), "<LocalLeader>", "<LocalLeader>", keymaps, { buffer = 0 })
end

return M
