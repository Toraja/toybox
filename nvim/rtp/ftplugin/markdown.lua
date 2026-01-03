vim.opt_local.conceallevel = 0
vim.opt_local.foldmethod = "marker"
vim.opt_local.formatoptions:append("ro")

require("text.edit").map_toggle_trailing(";", "  ", true)

local checkbox_ptn = "^([ \t]*)(- %[)(.)(%] )"
local checkbox_line_ptn = checkbox_ptn .. "(.*)"

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
	vim.api.nvim_set_current_line(replace_checkbox_state(vim.api.nvim_get_current_line(), command.fargs[1]))
end, { nargs = 1 })

-- Workaround to pass space as an argument
vim.api.nvim_buf_create_user_command(0, "MarkdownCheckboxStateUndone", function()
	vim.api.nvim_set_current_line(replace_checkbox_state(vim.api.nvim_get_current_line(), " "))
end, {})

local function conceal_toggle()
	vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end

vim.api.nvim_buf_create_user_command(0, "ConcealToggle", function()
	conceal_toggle()
end, {})

require("keymap.which-key-helper").register_for_ftplugin({
	c = { rhs = "MarkdownCheckboxStateSet ~", opts = { desc = "Checkbox cancelled" } },
	C = { rhs = "ConcealToggle", opts = { desc = "Toggle conceallevel between 0 and 2" } },
	d = { rhs = "MarkdownCheckboxStateSet X", opts = { desc = "Checkbox done" } },
	h = { rhs = "MarkdownCheckboxStateSet =", opts = { desc = "Checkbox on hold" } },
	p = { rhs = "MarkdownCheckboxStateSet /", opts = { desc = "Checkbox in progress" } },
	u = { rhs = "MarkdownCheckboxStateUndone", opts = { desc = "Checkbox undone" } },
	v = { rhs = "Markview Toggle", opts = { desc = "Toggle Markview" } },
})
