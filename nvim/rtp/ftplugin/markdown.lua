vim.opt_local.conceallevel = 0
vim.opt_local.foldmethod = "marker"
vim.opt_local.formatoptions:append("ro")
vim.opt_local.comments = { "b:*", "b:-", "b:+", "n:>" }

require("text.edit").map_toggle_trailing(";", "  ", true)

local checkbox_ptn = "^([ \t]*)(- %[)(.)(%] )"
local checkbox_line_ptn = checkbox_ptn .. "(.*)"
local checkbox_markers = {
	undone = " ",
	done = "X",
	in_progress = "/",
	cancelled = "~",
	on_hold = "=",
}

local function is_todo_line(line)
	return string.match(line, checkbox_line_ptn) ~= nil
end

local function replace_checkbox_state(line, state)
	if not is_todo_line(line) then
		print("not todo line")
		return
	end

	-- wrapping in parentheses returns only the first value
	return (string.gsub(line, checkbox_line_ptn, "%1%2" .. state .. "%4%5", 1))
end

vim.api.nvim_buf_create_user_command(0, "MarkdownCheckboxStateSet", function(command)
	local marker = checkbox_markers[command.fargs[1]]
	if not marker then
		error("invalid checkbox state: " .. command.fargs[1])
	end
	vim.api.nvim_set_current_line(replace_checkbox_state(vim.api.nvim_get_current_line(), marker))
end, { nargs = 1 })

local function conceal_toggle()
	vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end

vim.api.nvim_buf_create_user_command(0, "ConcealToggle", function()
	conceal_toggle()
end, {})

local todo_prefix_key = "t"
local todo_priority_prefix_key = todo_prefix_key .. "r"
require("keymap.which-key-helper").register_for_ftplugin({
	C = { rhs = "ConcealToggle", opts = { desc = "Toggle conceallevel between 0 and 2" } },
	[todo_prefix_key .. "c"] = {
		rhs = 'lua require("checkmate").toggle("cancelled"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO cancelled" },
	},
	[todo_prefix_key .. "d"] = {
		rhs = 'lua require("checkmate").toggle_metadata("done")',
		opts = { desc = "TODO done" },
	},
	[todo_prefix_key .. "h"] = {
		rhs = 'lua require("checkmate").toggle("on_hold"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO on hold" },
	},
	[todo_prefix_key .. "p"] = {
		rhs = 'lua require("checkmate").toggle("in_progress"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO in progress" },
	},
	[todo_priority_prefix_key .. "h"] = {
		rhs = 'lua require("checkmate").add_metadata("priority", "high")',
		opts = { desc = "TODO priority high" },
	},
	[todo_priority_prefix_key .. "l"] = {
		rhs = 'lua require("checkmate").add_metadata("priority", "low")',
		opts = { desc = "TODO priority low" },
	},
	[todo_priority_prefix_key .. "m"] = {
		rhs = 'lua require("checkmate").add_metadata("priority", "medium")',
		opts = { desc = "TODO priority medium" },
	},
	[todo_priority_prefix_key .. "r"] = {
		rhs = 'lua require("checkmate").remove_metadata("priority")',
		opts = { desc = "TODO priority high" },
	},
	[todo_prefix_key .. "s"] = {
		rhs = 'lua require("checkmate").toggle_metadata("started")',
		opts = { desc = "TODO started" },
	},
	[todo_prefix_key .. "u"] = {
		rhs = 'lua require("checkmate").toggle("unchecked"); require("checkmate").remove_metadata("done")',
		opts = { desc = "TODO undone" },
	},
	v = { rhs = "Markview Toggle", opts = { desc = "Toggle Markview" } },
})
