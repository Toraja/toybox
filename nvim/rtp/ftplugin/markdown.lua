vim.opt_local.conceallevel = 0
vim.opt_local.foldmethod = "marker"
vim.opt_local.formatoptions:append("ro")

require("text.edit").map_toggle_trailing(";", "  ", true)

local started_symbol = "STARTED "
local blocked_symbol = "BLOCKED "
local todo_checkbox_ptn = "^([ \t]*)(- %[(.)%] )"
local todo_line_ptn = todo_checkbox_ptn .. "(.*)"

local function is_todo_line(line)
	return string.match(line, todo_line_ptn) ~= nil
end

local function is_todo_status(line, status)
	return string.match(line, todo_checkbox_ptn .. status .. "(.*)") ~= nil
end

local function remove_todo_status(line, status)
	local updated_line = string.gsub(line, status, "", 1)
	vim.api.nvim_set_current_line(updated_line)
end

local function add_todo_status(line, status)
	local updated_line = string.gsub(line, todo_line_ptn, "%1%2" .. status .. "%4", 1)
	vim.api.nvim_set_current_line(updated_line)
end

local function todo_toggle_status(status)
	local current_line = vim.api.nvim_get_current_line()
	if not is_todo_line(current_line) then
		print("Current line does not have checkbox")
		return
	end

	if is_todo_status(current_line, status) then
		remove_todo_status(current_line, status)
	else
		add_todo_status(current_line, status)
	end
end

vim.api.nvim_buf_create_user_command(0, "ToDoToggleStatus", function(command)
	todo_toggle_status(command.fargs[1])
end, { nargs = 1 })

local function get_todo_checkbox_state(line)
	if not is_todo_line(line) then
		return
	end

	return string.gsub(line, todo_line_ptn, "%3", 1)
end

local function todo_toggle_cancelled(line)
	if not is_todo_line(line) then
		return
	end

	local new_checkbox_state = get_todo_checkbox_state(line) == "~" and " " or "~"
	local cancelled_todo = string.gsub(line, todo_line_ptn, "%1- [" .. new_checkbox_state .. "] %4", 1)
	vim.api.nvim_set_current_line(cancelled_todo)
end

vim.api.nvim_buf_create_user_command(0, "ToggleToDoCancelled", function()
	todo_toggle_cancelled(vim.api.nvim_get_current_line())
end, {})

local function conceal_toggle()
	vim.wo.conceallevel = vim.wo.conceallevel == 0 and 2 or 0
end

vim.api.nvim_buf_create_user_command(0, "ConcealToggle", function()
	conceal_toggle()
end, {})

local pomodoro_ptn = "%[pmd: %d+/%d+%]"
local function has_todo_line_pomodoro(line)
	return string.match(line, pomodoro_ptn) ~= nil
end

function todo_add_pomodoro()
	local current_line = vim.api.nvim_get_current_line()
	if not is_todo_line(current_line) then
		print("Current line does not have checkbox")
		return
	end

	if has_todo_line_pomodoro(current_line) then
		print("This TODO already has Pomodoro")
		return
	end

	local count = require("text.input").get_input("Pomodoro count: ")
	if count == nil then
		return
	end
	vim.api.nvim_set_current_line(current_line .. string.format(" [pmd: 0/%s]", count))
end

vim.api.nvim_buf_create_user_command(0, "ToDoAddPomodoro", function()
	todo_add_pomodoro()
end, {})

require("keymap.which-key-helper").register_for_ftplugin({
	b = { "ToDoToggleStatus " .. blocked_symbol, { desc = "Toggle BLOCKED" } },
	c = { "ConcealToggle", { desc = "Toggle conceallevel between 0 and 2" } },
	d = { "MkdnToggleToDo", { desc = "Toggle TODO status" } },
	-- D = { '', { desc = 'Remove TODO Checkbox' } },
	f = { "MkdnFoldSection", { desc = "Fold Section" } },
	F = { "MkdnUnfoldSection", { desc = "Unfold Section" } },
	-- l = { '', { desc = 'Toggle list' } },
	p = { "ToDoAddPomodoro", { desc = "Add pomodoro" } },
	s = { "ToDoToggleStatus " .. started_symbol, { desc = "Toggle STARTED" } },
	v = { "Glow", { desc = "Glow" } },
	x = { "ToggleToDoCancelled", { desc = "Cancel TODO" } },
})
